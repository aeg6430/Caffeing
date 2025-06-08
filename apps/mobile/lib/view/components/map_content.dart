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
  double _currentZoom = 12.5;
  bool _isMovingCamera = false;
  final double defaultLatitude = 25.05291553866105;
  final double defaultLongitude = 121.52035694040113;
  Offset? _pulsePosition;

  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeAppContent();
  }

  Future<void> _initializeAppContent() async {
    print('MapContent: _initializeAppContent started.');
    try {
      await Future.wait([_loadMapStyle(), _loadCustomMarkerIcons()]);

      print('MapContent: Map style and custom marker icons loaded.');

      // Initialize cluster manager only if storeList is provided and not empty
      if (widget.storeList != null && widget.storeList!.isNotEmpty) {
        _initializeClusterManager();
        print('MapContent: ClusterManager initialized.');
      } else {
        print(
          'MapContent: No storeList provided or storeList is empty. ClusterManager not initialized.',
        );
      }
    } catch (e) {
      print('MapContent: Error during _initializeAppContent: $e');
      rethrow; // Propagate the error to FutureBuilder
    }
  }

  @override
  void didUpdateWidget(covariant MapContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('MapContent: didUpdateWidget called.');

    // If search results change, trigger map update for existing cluster manager
    if (widget.searchResults != oldWidget.searchResults) {
      print(
        'MapContent: searchResults changed. Updating map via cluster manager.',
      );
      _clusterManager?.updateMap();
    }

    // If store list changes, re-initialize the cluster manager.
    // Ensure icons are loaded, which _initializeAppContent should guarantee.
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
    _controller.future.then((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print('MapContent: FutureBuilder error: ${snapshot.error}');
            return Center(child: Text('Error loading map: ${snapshot.error}'));
          } else {
            return Selector<MapViewModel, StoreSummaryResponseModel?>(
              selector: (_, vm) => vm.selectedStore,
              builder: (context, selectedStore, _) {
                if (selectedStore != null) {
                  if (_selectedMarkerId != selectedStore.storeId) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _updateMarkerPosition();
                    });
                  }
                }

                final lat = selectedStore?.latitude ?? defaultLatitude;
                final lng = selectedStore?.longitude ?? defaultLongitude;

                return Stack(
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
                        print('MapContent: onMapCreated called.');
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                          // Get and set the initial actual zoom level of the map
                          controller.getZoomLevel().then((zoom) {
                            if (mounted) {
                              setState(() {
                                _currentZoom = zoom;
                                print(
                                  'MapContent: _currentZoom set to $zoom after map created.',
                                );
                              });
                            }
                          });
                        }
                        // Ensure cluster manager gets map ID and updates its markers after map creation
                        _clusterManager?.setMapId(controller.mapId);
                        _clusterManager?.updateMap();
                        print(
                          'MapContent: ClusterManager mapId set and map updated after creation.',
                        );
                      },
                      onCameraMove: (CameraPosition position) {
                        _currentZoom = position.zoom;
                        _clusterManager?.onCameraMove(position);
                      },
                      onCameraIdle: () {
                        _clusterManager?.updateMap();
                      },
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
        } else {
          print(
            'MapContent: FutureBuilder connectionState: ${snapshot.connectionState}. Showing CircularProgressIndicator.',
          );
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> _loadMapStyle() async {
    print('MapContent: _loadMapStyle called.');
    _mapStyle = await rootBundle.loadString('assets/map_style_light.json');
    print('MapContent: Map style loaded.');
  }

  Future<void> _loadCustomMarkerIcons() async {
    print('MapContent: _loadCustomMarkerIcons called.');
    _defaultMarkerIcon = await MapHelper.createCircleMarker(Colors.orange);
    _searchMarkerIcon = await MapHelper.createCircleMarker(Colors.lightGreen);
    _selectedMarkerIcon = await MapHelper.createCircleMarker(Colors.red);
    print('MapContent: Custom marker icons loaded.');
  }

  void _initializeClusterManager() {
    print('MapContent: _initializeClusterManager called.');
    if (widget.storeList == null || widget.storeList!.isEmpty) {
      print(
        'MapContent: storeList is null or empty, not initializing ClusterManager.',
      );
      _clusterManager = null; // Ensure no old manager is lingering
      return;
    }

    final items =
        widget.storeList?.map((store) {
          return StoreClusterModel(
            storeId: store.storeId,
            name: store.name,
            latLng: LatLng(store.latitude, store.longitude),
          );
        }).toList() ??
        [];

    // Defensive check (should be true if _initializeAppContent completed)
    if (_defaultMarkerIcon == null ||
        _selectedMarkerIcon == null ||
        _searchMarkerIcon == null) {
      print(
        "MapContent: ERROR: Marker icons are null during ClusterManager initialization! This should not happen.",
      );
      return;
    }

    _clusterManager = cluster_manager.ClusterManager(
      items,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: const [1, 5.5, 7.5, 9.5, 11.5, 13.5, 15, 16, 17, 18],
      stopClusteringZoom: 17.5,
      extraPercent: 0.3,
    );
    print('MapContent: ClusterManager instance created.');

    // Attempt to update map using the new cluster manager if controller is already complete.
    // This handles cases where _initializeClusterManager is called *after* map creation.
    _controller.future
        .then((controller) {
          _clusterManager?.setMapId(controller.mapId);
          _clusterManager?.updateMap();
          print(
            'MapContent: ClusterManager mapId set and map updated (post-init).',
          );
        })
        .catchError((error) {
          print(
            "MapContent: Error getting map controller for _initializeClusterManager's updateMap: $error",
          );
        });
  }

  void _updateMarkers(Set<Marker> markers) {
    if (!mounted) {
      print('MapContent: _updateMarkers called, but widget is unmounted.');
      return;
    }
    setState(() {
      final newMarkers = Set<Marker>.from(markers);
      if (_userMarker != null) {
        newMarkers.add(_userMarker!);
      }
      _mapMarkers = newMarkers;
    });

    // This part should be safe now that the map is guaranteed to be built
    // Use `WidgetsBinding.instance.addPostFrameCallback` for UI updates like this
    // to avoid triggering setState during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = Provider.of<MapViewModel>(context, listen: false);
      final selectedStore = vm.selectedStore;
      // Only call _updateMarkerPosition if a store is selected and we haven't already marked it
      if (selectedStore != null && _selectedMarkerId != selectedStore.storeId) {
        print(
          'MapContent: _updateMarkers: selectedStore is available, calling _updateMarkerPosition.',
        );
        _updateMarkerPosition();
      }
    });
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

      // Make sure MapHelper.createCircleMarker doesn't return null
      final icon = await MapHelper.createCircleMarker(
        color,
        count: cluster.count,
      );
      return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        icon: icon,
        onTap: () {
          print('MapContent: Cluster tapped at zoom: $_currentZoom');
          final currentZoomLevel = _currentZoom;
          // Zoom in more aggressively if current zoom is low, otherwise to a fixed high zoom
          final targetZoom = currentZoomLevel < 17.5 ? 17.5 : 19.0;
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
          print(
            'MapContent: Store marker tapped: ${storeCluster.name} (ID: ${storeCluster.storeId})',
          );
          final summary = StoreSummaryResponseModel(
            storeId: storeCluster.storeId,
            name: storeCluster.name,
            latitude: cluster.location.latitude,
            longitude: cluster.location.longitude,
          );

          widget.onStoreSelected?.call(summary);
          if (mounted) {
            setState(() {
              _selectedMarkerId = storeCluster.storeId;
              _markerPosition = cluster.location;
            });
          }
        },
      );
    }
  };

  Future<void> _goToCurrentLocation() async {
    if (!mounted) return;
    print('MapContent: _goToCurrentLocation called.');
    final controller = await _controller.future;
    _positionStream?.cancel(); // Cancel any existing stream

    _positionStream = await MapHelper.trackUserLocation(
      controller: controller,
      markerSet: _mapMarkers,
      updateMarkers: (updated) {
        if (mounted) {
          setState(() => _mapMarkers = updated);
          print(
            'MapContent: _goToCurrentLocation: _mapMarkers updated with user marker.',
          );
        }
      },
      onLocationUpdate: (latLng, marker) {
        if (mounted) {
          setState(() {
            _userLocation = latLng;
            _userMarker = marker;
            print(
              'MapContent: _goToCurrentLocation: User location updated to $latLng',
            );
          });
        }
      },
    );
  }

  Future<void> _updateMarkerPosition() async {
    if (!mounted) return;

    final vm = Provider.of<MapViewModel>(context, listen: false);
    final store = vm.selectedStore;

    if (store == null) {
      print('MapContent: _updateMarkerPosition: No selected store, returning.');
      return;
    }

    if (_isMovingCamera || !_controller.isCompleted) {
      print(
        'MapContent: _updateMarkerPosition: Camera already moving or controller not ready. Deferring.',
      );
      return;
    }

    final newPosition = LatLng(store.latitude, store.longitude);
    final GoogleMapController controller = await _controller.future;

    setState(() {
      // Set _isMovingCamera before starting animation
      _isMovingCamera = true;
      print('MapContent: _isMovingCamera set to true.');
    });

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

    if (mounted) {
      setState(() {
        _markerPosition = newPosition;
        _selectedMarkerId = store.storeId;
        _isMovingCamera = false;
      });
    }

    // After state is updated, markers need to be rebuilt to reflect the new selection.
    // Call updateMap on cluster manager after camera movement is complete and state is updated.
    _clusterManager?.updateMap();
  }
}
