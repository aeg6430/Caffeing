import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapContent extends StatefulWidget {
  final StoreSummaryResponseModel? store;
  final double zoom;

  const MapContent({Key? key, required this.store, this.zoom = 14})
    : super(key: key);

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  GoogleMapController? _mapController;
  LatLng? _markerPosition;

  // Default location
  double defaultLatitude = 25.05291553866105;
  double defaultLongitude = 121.52035694040113;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMarkerPosition();
  }

  @override
  void didUpdateWidget(covariant MapContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateMarkerPosition();
  }

  void _updateMarkerPosition() async {
    final store = widget.store;

    final latitude = store?.latitude ?? defaultLatitude;
    final longitude = store?.longitude ?? defaultLongitude;

    final newPosition = LatLng(latitude, longitude);

    if (_markerPosition != newPosition) {
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: widget.zoom),
        ),
      );
      setState(() {
        _markerPosition = newPosition;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    // Use the store's location or fallback to default location
    final initialLatitude = store?.latitude ?? defaultLatitude;
    final initialLongitude = store?.longitude ?? defaultLongitude;

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _markerPosition ?? LatLng(initialLatitude, initialLongitude),
        zoom: widget.zoom,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
      },
      markers:
          _markerPosition == null
              ? {}
              : {
                Marker(
                  markerId: MarkerId(store?.storeId ?? 'default'),
                  position: _markerPosition!,
                  infoWindow: InfoWindow(
                    title:
                        'Marker at ${_markerPosition!.latitude}, ${_markerPosition!.longitude}',
                  ),
                ),
              },
    );
  }
}
