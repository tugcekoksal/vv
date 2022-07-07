import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/carte_provider/carte_bike_provider.dart';
import 'package:velyvelo/models/carte/bike_map_model.dart';

import 'package:velyvelo/screens/views/bike_profile/bike_profile_view.dart';

Future<void> goToBikeProfileFromMarker(
    Marker marker, CarteBikeProvider bikeMap) async {
  BikeMapModel bike = bikeMap.getBikeFromMarker(marker);
  Get.to(
      () => Scaffold(
          resizeToAvoidBottomInset: true,
          body: MyBikeView(
            isFromScan: false,
            veloPk: bike.id ?? -1,
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
