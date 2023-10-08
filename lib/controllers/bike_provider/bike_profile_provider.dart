// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';
import 'package:velyvelo/config/api_request.dart';

// Controllers
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/bike/user_bike_model.dart';

// Models

//DATE FORMAT
// Services
import 'package:velyvelo/services/http_service.dart';

final bikeProfileProvider =
    ChangeNotifierProvider.autoDispose<BikeProfileProvider>(
        (ref) => BikeProfileProvider());

class BikeProfileProvider extends ChangeNotifier {
  String userToken = "";
  String messageError = "";

  bool isViewingScanPage = false;
  bool isLoading = true;
  bool isBikeIncidentsOpen = false;

  UserBikeModel userBike = UserBikeModel();

  final log = logger(BikeProfileProvider);

  // Initialisation
  BikeProfileProvider() {
    getTokenFromSharedPref().then((token) => {
          userToken = token,
        });
  }

  void setVeloPk(int veloPk) {
    userBike.veloPk = veloPk;
    notifyListeners();
  }

  Future<void> fetchUserBike({int? veloPk, String? nomVelo}) async {
    messageError = "";
    isLoading = true;
    if (userToken == "") {
      userToken = await getTokenFromSharedPref();
    }
    try {
      userBike = await HttpService.fetchUserBike(veloPk, nomVelo, userToken);
    } catch (e) {
      log.e(e);
      messageError =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
    isLoading = false;
    notifyListeners();
  }

  toggleIsBikeIncidentsOpen() {
    isBikeIncidentsOpen = !isBikeIncidentsOpen;
    notifyListeners();
  }

  Future setBikeToNewRobbedStatus(bool isRobbed, int veloPk) async {
    try {
      String messageBikeRobbed =
          await HttpService.setBikeRobbed(veloPk, isRobbed, userToken);
      log.d(messageBikeRobbed);
    } on SocketException {
      try {
        failedRequestFunctions.add(() =>
            HttpService.setBikeRobbed(veloPk, isRobbed, userToken));
      } catch (e) {
        log.e(e);
      }
    }
    notifyListeners();
  }


  void fetchBikeIDIfUser() async {
    isLoading = true;
    try {
      var userTypeFetched = await HttpService.fetchTypeUser(userToken);
      if (userTypeFetched == "Utilisateur") {
        var bikeID = await HttpService.fetchBikeIDUser(userToken);
        if (bikeID != null) {
          userBike.veloPk = bikeID;
        }
      } else {
        log.d("Not a user");
      }
    } catch (e) {
      log.e(e);
    }
    isLoading = false;
  }
}
