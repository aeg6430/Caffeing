import 'dart:async';
import 'dart:ui' as ui;
import 'package:caffeing/models/response/store/store_cluster_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart'
    as cluster_manager;
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/view_model/map/map_view_model.dart';

class MapContent extends StatefulWidget {
  final List<StoreResponseModel>? storeList;
  final double zoom;

  const MapContent({Key? key, this.storeList, this.zoom = 10})
    : super(key: key);

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  cluster_manager.ClusterManager? _clusterManager;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _mapMarkers = {};
  LatLng? _markerPosition;
  String? _selectedMarkerId;
  BitmapDescriptor? _defaultMarkerIcon;
  BitmapDescriptor? _selectedMarkerIcon;
  bool _isLoading = true;
  double _currentZoom = 10;
  final double defaultLatitude = 25.05291553866105;
  final double defaultLongitude = 121.52035694040113;

  @override
  void initState() {
    super.initState();
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
      levels: [10, 12, 13, 14, 15, 16, 17, 18],
      stopClusteringZoom: 17,
      extraPercent: 0.1,
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
          final targetZoom = currentZoomLevel < 17.5 ? 18.0 : currentZoomLevel;
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
          final vm = Provider.of<MapViewModel>(context, listen: false);
          vm.updateSelectedStore(
            StoreSummaryResponseModel(
              storeId: storeCluster.storeId,
              name: storeCluster.name,
              latitude: cluster.location.latitude,
              longitude: cluster.location.longitude,
            ),
          );

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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateMarkerPosition();
          });
        }

        final lat = selectedStore?.latitude ?? defaultLatitude;
        final lng = selectedStore?.longitude ?? defaultLongitude;

        return _isLoading
            ? Center(child: CircularProgressIndicator())
            : GoogleMap(
              mapType: MapType.normal,
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

  Future<void> _updateMarkerPosition() async {
    if (!_controller.isCompleted || _selectedMarkerId == null) return;

    final vm = Provider.of<MapViewModel>(context, listen: false);
    final store = vm.selectedStore;
    if (store == null) return;

    final newPosition = LatLng(store.latitude, store.longitude);
    if (_markerPosition != newPosition) {
      setState(() {
        _markerPosition = newPosition;
        _selectedMarkerId = store.storeId;
      });

      final controller = await _controller.future;

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: widget.zoom),
        ),
      );
    }
  }
}
