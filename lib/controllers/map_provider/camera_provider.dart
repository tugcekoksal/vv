// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

// Handle camera and zoom position on the map
final cameraProvider =
    ChangeNotifierProvider.autoDispose<CameraProvider>((ref) {
  return CameraProvider();
});

class CameraProvider extends ChangeNotifier {
  bool streetView = true;
  double oldZoom = 0;
  LatLng oldPosition = LatLng(0, 0);
  bool firstTime = true;

  void toggleStreetView(bool view) {
    streetView = view;
    notifyListeners();
  }

  void updateZoom(double zoom) {
    oldZoom = zoom;
    notifyListeners();
  }

  void updatePosition(LatLng pos) {
    oldPosition = pos;
    notifyListeners();
  }
}
