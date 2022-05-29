// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Handle camera and zoom position on the map
final mapViewProvider = ChangeNotifierProvider<MapViewProvider>((ref) {
  return MapViewProvider();
});

enum WhichMapView { bikeView, hubView }

enum MapOrList { map, list }

class MapViewProvider extends ChangeNotifier {
  WhichMapView view = WhichMapView.bikeView;
  MapOrList mol = MapOrList.map;

  void toggleMapView(WhichMapView newView) {
    view = newView;
    notifyListeners();
  }

  bool isActiveMapView(WhichMapView xView) {
    return xView == view;
  }

  void toggleMapOrList(MapOrList xMol) {
    mol = xMol;
    notifyListeners();
  }

  void switchMapOrList() {
    if (mol == MapOrList.list) {
      mol = MapOrList.map;
    } else {
      mol = MapOrList.list;
    }
  }

  bool isMapOrList(MapOrList xMol) {
    return xMol == mol;
  }
}
