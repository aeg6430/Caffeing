import 'dart:async';
import 'package:caffeing/models/response/store/store_cluster_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:caffeing/utils/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart'
    as cluster_manager;
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/view_model/map/map_view_model.dart';

class MapContent extends StatefulWidget {
  final double zoom;
  final List<StoreResponseModel>? storeList;
  final List<StoreSummaryResponseModel>? searchResults;
  final void Function(StoreSummaryResponseModel)? onStoreSelected;
  const MapContent({
    Key? key,
    this.zoom = 10,
    this.storeList,
    this.searchResults,
    this.onStoreSelected,
  }) : super(key: key);

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  cluster_manager.ClusterManager? _clusterManager;
  final Completer<GoogleMapController> _controller = Completer();
  String? _mapStyle;
  Set<Marker> _mapMarkers = {};
  LatLng? _markerPosition;
  String? _selectedMarkerId;
  Marker? _userMarker;
  LatLng? _userLocation;
  StreamSubscription<Position>? _positionStream;
  BitmapDescriptor? _defaultMarkerIcon;
  BitmapDescriptor? _searchMarkerIcon;
  BitmapDescriptor? _selectedMarkerIcon;
  bool _isLoading = true;
  double _currentZoom = 12.5;
  bool _isMovingCamera = false;
  final double defaultLatitude = 25.05291553866105;
  final double defaultLongitude = 121.52035694040113;
  Offset? _pulsePosition;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _loadCustomMarkerIcons();
  }

  @override
  void didUpdateWidget(covariant MapContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchResults != oldWidget.searchResults) {
      _clusterManager?.updateMap();
    }

    if (widget.storeList != null &&
        widget.storeList != oldWidget.storeList &&
        _defaultMarkerIcon != null &&
        _selectedMarkerIcon != null) {
      _initializeClusterManager();
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, StoreSummaryResponseModel?>(
      selector: (_, vm) => vm.selectedStore,
      builder: (context, selectedStore, _) {
        if (selectedStore != null) {
          if (_selectedMarkerId != selectedStore?.storeId) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateMarkerPosition();
            });
          }
        }

        final lat = selectedStore?.latitude ?? defaultLatitude;
        final lng = selectedStore?.longitude ?? defaultLongitude;

        return _isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  style: _mapStyle,
                  initialCameraPosition: CameraPosition(
                    target: _markerPosition ?? LatLng(lat, lng),
                    zoom: widget.zoom,
                  ),
                  markers: _mapMarkers,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                    _clusterManager?.setMapId(controller.mapId);
                    _clusterManager?.updateMap();
                  },
                  onCameraMove: (CameraPosition position) {
                    _currentZoom = position.zoom;
                    _clusterManager?.onCameraMove(position);
                  },
                  onCameraIdle: _clusterManager?.updateMap,
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: FloatingActionButton(
                    onPressed: _goToCurrentLocation,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.my_location,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            );
      },
    );
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style_light.json');
    setState(() {});
  }

  Future<void> _loadCustomMarkerIcons() async {
    _defaultMarkerIcon = await MapHelper.createCircleMarker(Colors.orange);
    _searchMarkerIcon = await await MapHelper.createCircleMarker(
      Colors.lightGreen,
    );
    _selectedMarkerIcon = await await MapHelper.createCircleMarker(Colors.red);
    if (mounted && widget.storeList != null) {
      _initializeClusterManager();
    }
    setState(() => _isLoading = false);
  }

  void _initializeClusterManager() {
    if (widget.storeList == null || widget.storeList!.isEmpty) return;
    final items =
        widget.storeList?.map((store) {
          return StoreClusterModel(
            storeId: store.storeId,
            name: store.name,
            latLng: LatLng(store.latitude, store.longitude),
          );
        }).toList() ??
        [];

    _clusterManager = cluster_manager.ClusterManager(
      items,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: [1, 5.5, 7.5, 9.5, 11.5, 13.5, 15, 16, 17, 18],
      stopClusteringZoom: 17.5,
      extraPercent: 0.3,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clusterManager?.updateMap();
    });
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      // Retain the user marker if available
      final newMarkers = Set<Marker>.from(markers);
      if (_userMarker != null) {
        newMarkers.add(_userMarker!);
      }
      _mapMarkers = newMarkers;
    });

    final vm = Provider.of<MapViewModel>(context, listen: false);
    final selectedStore = vm.selectedStore;
    if (selectedStore != null && _selectedMarkerId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateMarkerPosition();
      });
    }
  }

  Future<Marker> Function(cluster_manager.Cluster<cluster_manager.ClusterItem>)
  get _markerBuilder => (cluster) async {
    final containsSelected = cluster.items.any(
      (item) => (item as StoreClusterModel).storeId == _selectedMarkerId,
    );

    final containsSearchResult = cluster.items.any(
      (item) =>
          widget.searchResults?.any(
            (s) => s.storeId == (item as StoreClusterModel).storeId,
          ) ??
          false,
    );

    if (cluster.isMultiple) {
      final color =
          containsSelected
              ? Colors.red
              : containsSearchResult
              ? Colors.lightGreen
              : Colors.orange;

      final icon = await MapHelper.createCircleMarker(
        color,
        count: cluster.count,
      );

      return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        icon: icon,
        onTap: () {
          final currentZoomLevel = _currentZoom;
          final targetZoom = currentZoomLevel < 18.5 ? 19.0 : currentZoomLevel;
          _controller.future.then((controller) {
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(cluster.location, targetZoom),
            );
          });
        },
      );
    } else {
      final storeCluster = cluster.items.first as StoreClusterModel;
      final isSearchResult =
          widget.searchResults?.any((s) => s.storeId == storeCluster.storeId) ??
          false;
      final isSelected = _selectedMarkerId == storeCluster.storeId;

      BitmapDescriptor icon;
      if (isSelected) {
        icon = _selectedMarkerIcon!;
      } else if (isSearchResult) {
        icon = _searchMarkerIcon!;
      } else {
        icon = _defaultMarkerIcon!;
      }

      return Marker(
        markerId: MarkerId(storeCluster.storeId),
        position: cluster.location,
        icon: icon,
        onTap: () {
          final summary = StoreSummaryResponseModel(
            storeId: storeCluster.storeId,
            name: storeCluster.name,
            latitude: cluster.location.latitude,
            longitude: cluster.location.longitude,
          );

          widget.onStoreSelected?.call(summary);
          setState(() {
            _selectedMarkerId = storeCluster.storeId;
            _markerPosition = cluster.location;
          });
        },
      );
    }
  };

  Future<void> _goToCurrentLocation() async {
    final controller = await _controller.future;
    _positionStream?.cancel();

    _positionStream = await MapHelper.trackUserLocation(
      controller: controller,
      markerSet: _mapMarkers,
      updateMarkers: (updated) => setState(() => _mapMarkers = updated),
      onLocationUpdate: (latLng, marker) {
        setState(() {
          _userLocation = latLng;
          _userMarker = marker;
        });
      },
    );
  }

  Future<void> _updateMarkerPosition() async {
    final vm = Provider.of<MapViewModel>(context, listen: false);
    final store = vm.selectedStore;

    // If there's no store to select/move to in the ViewModel, do nothing.
    if (store == null) {
      return;
    }

    // If camera is already moving or map controller isn't ready, defer.
    if (_isMovingCamera || !_controller.isCompleted) {
      return;
    }

    final newPosition = LatLng(store.latitude, store.longitude);
    final GoogleMapController controller = await _controller.future;

    _isMovingCamera = true;

    final LatLng? previousMarkerPosition = _markerPosition;

    final distance =
        previousMarkerPosition == null
            ? double.infinity
            : Geolocator.distanceBetween(
              previousMarkerPosition.latitude,
              previousMarkerPosition.longitude,
              newPosition.latitude,
              newPosition.longitude,
            );

    if (distance > 10000 && previousMarkerPosition != null) {
      await MapHelper.smoothMoveAcrossDistance(
        controller: controller,
        from: previousMarkerPosition,
        to: newPosition,
      );
    } else {
      await MapHelper.smoothZoomTo(
        controller: controller,
        fromZoom: _currentZoom,
        toZoom: 18.5,
        target: newPosition,
      );
    }

    setState(() {
      _markerPosition = newPosition;
      _selectedMarkerId = store.storeId;
    });

    // After state is updated, markers need to be rebuilt to reflect the new selection.
    _clusterManager?.updateMap();
    _isMovingCamera = false;
  }
}
