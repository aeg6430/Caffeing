import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapContent extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  const MapContent({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.zoom = 14,
  }) : super(key: key);

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  late GoogleMapController _mapController;
  late LatLng _markerPosition;
  @override
  void initState() {
    super.initState();
    _markerPosition = LatLng(widget.latitude, widget.longitude);
  }

  @override
  void didUpdateWidget(covariant MapContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _moveCameraTo(widget.latitude, widget.longitude);
    }
  }

  void _moveCameraTo(double lat, double lng, {double? zoom}) {
    final position = CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoom ?? widget.zoom,
    );
    _mapController.animateCamera(CameraUpdate.newCameraPosition(position));

    setState(() {
      _markerPosition = LatLng(lat, lng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _markerPosition,
        zoom: widget.zoom,
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      markers: Set<Marker>.of([
        Marker(
          markerId: MarkerId('marker_1'),
          position: _markerPosition,
          infoWindow: InfoWindow(
            title:
                'Marker at ${_markerPosition.latitude}, ${_markerPosition.longitude}',
          ),
        ),
      ]),
    );
  }
}
