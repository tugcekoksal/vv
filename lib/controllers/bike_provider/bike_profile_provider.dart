// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controllers
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/bike/user_bike_model.dart';
import 'package:velyvelo/helpers/logger.dart';

// Models
import 'package:velyvelo/models/map/map_model.dart';

//DATE FORMAT
import 'package:intl/intl.dart';
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
    // fetchUserBike(veloPk).then((value) => {notifyListeners()});
  }

  Future<void> fetchUserBike(int veloPk) async {
    messageError = "";
    isLoading = true;
    if (userToken == "") {
      userToken = await getTokenFromSharedPref();
    }
    try {
      userBike = await HttpService.fetchUserBike(veloPk, userToken);
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
    } catch (e) {
      log.e(e);
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
