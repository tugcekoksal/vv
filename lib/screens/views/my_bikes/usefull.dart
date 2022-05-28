import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/bike_provider/bikes_provider.dart';

import 'package:velyvelo/models/map/map_model.dart';
import 'package:velyvelo/screens/views/bike_profile/bike_profile_view.dart';

Future<void> goToBikeProfileFromMarker(
    Marker marker, BikesProvider bikes) async {
  MapModel bike = bikes.getBikeFromMarker(marker);
  Get.to(
      () => Scaffold(
          resizeToAvoidBottomInset: true,
          body: MyBikeView(
            isFromScan: false,
            veloPk: bike.veloPk,
          )),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 400));
}

Future<void> goToBikeProfileFromPk(int veloPk) async {
  Get.to(
      () => Scaffold(
          resizeToAvoidBottomInset: true,
          body: MyBikeView(
            isFromScan: false,
            veloPk: veloPk,
          )),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 400));
}
