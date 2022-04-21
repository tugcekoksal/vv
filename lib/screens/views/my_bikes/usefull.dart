import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/models/map/map_model.dart';
import 'package:velyvelo/screens/views/my_bike_view.dart';

Future<void> goToBikeProfileFromMarker(
    Marker marker, MapBikesController mapBikeController) async {
  MapModel bike = mapBikeController.getBikeFromMarker(marker);
  Get.to(Scaffold(
      body: MyBikeView(
    isFromScan: false,
    veloPk: bike.veloPk,
  )));
}

Future<void> goToBikeProfileFromPk(
    int veloPk, MapBikesController mapBikeController) async {
  Get.to(Scaffold(
      body: MyBikeView(
    isFromScan: false,
    veloPk: veloPk,
  )));
}
