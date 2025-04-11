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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      child: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: widget.zoom,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('center_marker'),
            position: LatLng(widget.latitude, widget.longitude),
          ),
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}
