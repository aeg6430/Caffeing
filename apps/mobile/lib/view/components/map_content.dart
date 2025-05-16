import 'dart:async';
import 'dart:ui' as ui;
import 'package:caffeing/models/response/store/store_cluster_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
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
  final List<StoreResponseModel>? storeList;
  final double zoom;
  final void Function(StoreSummaryResponseModel)? onStoreSelected;
  const MapContent({
    Key? key,
    this.storeList,
    this.zoom = 10,
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
  BitmapDescriptor? _defaultMarkerIcon;
  BitmapDescriptor? _selectedMarkerIcon;
  bool _isLoading = true;
  double _currentZoom = 12.5;
  bool _isMovingCamera = false;
  final double defaultLatitude = 25.05291553866105;
  final double defaultLongitude = 121.52035694040113;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _loadCustomMarkerIcons();
  }

  @override
  void didUpdateWidget(covariant MapContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.storeList != null &&
        widget.storeList != oldWidget.storeList &&
        _defaultMarkerIcon != null &&
        _selectedMarkerIcon != null) {
      _initializeClusterManager();
    }
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style_light.json');
    setState(() {});
  }

  Future<void> _loadCustomMarkerIcons() async {
    _defaultMarkerIcon = await _createCircleMarker(Colors.orange);
    _selectedMarkerIcon = await _createCircleMarker(Colors.red);
    if (mounted && widget.storeList != null) {
      _initializeClusterManager();
    }
    setState(() => _isLoading = false);
  }

  Future<BitmapDescriptor> _createCircleMarker(
    Color color, {
    int? count,
  }) async {
    const int size = 30;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final double radius = size / 2;

    final Paint paint = Paint()..color = color;
    canvas.drawCircle(Offset(radius, radius), radius, paint);

    final Paint borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
    canvas.drawCircle(Offset(radius, radius), radius - 3, borderPaint);

    if (count != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: count.toString(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
      );
    }

    final ui.Image image = await recorder.endRecording().toImage(size, size);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
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
      _mapMarkers = markers;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clusterManager?.updateMap();

      // If selectedStore exists, move to it once markers are ready
      final vm = Provider.of<MapViewModel>(context, listen: false);
      final selectedStore = vm.selectedStore;
      if (selectedStore != null && _selectedMarkerId == null) {
        _updateMarkerPosition();
      }
    });
  }

  Future<Marker> Function(cluster_manager.Cluster<cluster_manager.ClusterItem>)
  get _markerBuilder => (cluster) async {
    final containsSelected = cluster.items.any(
      (item) => (item as StoreClusterModel).storeId == _selectedMarkerId,
    );

    if (cluster.isMultiple) {
      final icon = await _createCircleMarker(
        containsSelected ? Colors.red : Colors.orange,
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
      final isSelected = _selectedMarkerId == storeCluster.storeId;

      return Marker(
        markerId: MarkerId(storeCluster.storeId),
        position: cluster.location,
        icon: isSelected ? _selectedMarkerIcon! : _defaultMarkerIcon!,
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
            : GoogleMap(
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
            );
      },
    );
  }

  Future<void> _smoothZoomTo({
    required GoogleMapController controller,
    required double fromZoom,
    required double toZoom,
    required LatLng target,
    Duration totalDuration = const Duration(milliseconds: 1000),
    int steps = 20,
  }) async {
    final stepZoom = (toZoom - fromZoom) / steps;
    final stepDuration = totalDuration ~/ steps;

    for (int i = 1; i <= steps; i++) {
      final newZoom = fromZoom + stepZoom * i;

      // Use moveCamera for faster, smoother transition in early steps
      if (i < steps) {
        await controller.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: newZoom),
          ),
        );
      } else {
        // AnimateCamera for smooth finish
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: newZoom),
          ),
        );
      }

      await Future.delayed(stepDuration);
    }
  }

  Future<void> _smoothMoveAcrossDistance({
    required GoogleMapController controller,
    required LatLng from,
    required LatLng to,
    double minZoom = 10.0,
    double maxZoom = 19.0,
    Duration zoomOutDuration = const Duration(milliseconds: 1000),
    Duration moveDuration = const Duration(milliseconds: 500),
    Duration zoomInDuration = const Duration(milliseconds: 1500),
  }) async {
    // Zoom out
    final zoomOutCamera = CameraUpdate.newCameraPosition(
      CameraPosition(target: from, zoom: minZoom),
    );
    await controller.animateCamera(zoomOutCamera);
    await Future.delayed(zoomOutDuration);

    // Pan to new target (at wide zoom)
    final panCamera = CameraUpdate.newLatLng(to);
    await controller.animateCamera(panCamera);
    await Future.delayed(moveDuration);

    // Smooth zoom into target
    await _smoothZoomTo(
      controller: controller,
      fromZoom: minZoom,
      toZoom: maxZoom,
      target: to,
      totalDuration: zoomInDuration,
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
      await _smoothMoveAcrossDistance(
        controller: controller,
        from: previousMarkerPosition,
        to: newPosition,
      );
    } else {
      await _smoothZoomTo(
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
