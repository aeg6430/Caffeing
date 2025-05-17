import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHelper {
  static Future<BitmapDescriptor> createCircleMarker(
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

  static Future<void> smoothZoomTo({
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

      if (i < steps) {
        await controller.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: newZoom),
          ),
        );
      } else {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: newZoom),
          ),
        );
      }

      await Future.delayed(stepDuration);
    }
  }

  static Future<void> smoothMoveAcrossDistance({
    required GoogleMapController controller,
    required LatLng from,
    required LatLng to,
    double minZoom = 10.0,
    double maxZoom = 19.0,
    Duration zoomOutDuration = const Duration(milliseconds: 1000),
    Duration moveDuration = const Duration(milliseconds: 500),
    Duration zoomInDuration = const Duration(milliseconds: 1500),
  }) async {
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: from, zoom: minZoom),
      ),
    );
    await Future.delayed(zoomOutDuration);

    await controller.animateCamera(CameraUpdate.newLatLng(to));
    await Future.delayed(moveDuration);

    await smoothZoomTo(
      controller: controller,
      fromZoom: minZoom,
      toZoom: maxZoom,
      target: to,
      totalDuration: zoomInDuration,
    );
  }

  static Future<StreamSubscription<Position>?> trackUserLocation({
    required void Function(LatLng latLng, Marker marker) onLocationUpdate,
    required GoogleMapController controller,
    required Set<Marker> markerSet,
    required void Function(Set<Marker>) updateMarkers,
    double zoom = 17,
    Color markerColor = Colors.blue,
  }) async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    final firstPosition = await Geolocator.getCurrentPosition();
    final firstLatLng = LatLng(firstPosition.latitude, firstPosition.longitude);

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(firstLatLng, zoom),
    );

    final subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) async {
      final latLng = LatLng(position.latitude, position.longitude);
      final icon = await createCircleMarker(markerColor);

      final marker = Marker(
        markerId: const MarkerId("user_location"),
        position: latLng,
        icon: icon,
        zIndex: 100,
      );

      markerSet.removeWhere((m) => m.markerId.value == "user_location");
      markerSet.add(marker);
      updateMarkers(markerSet);

      onLocationUpdate(latLng, marker);
    });

    return subscription;
  }
}
