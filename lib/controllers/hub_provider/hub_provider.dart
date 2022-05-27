// Vendor
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';

// Models
import 'package:velyvelo/models/hubs/hub_map.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

final hubProvider =
    ChangeNotifierProvider.autoDispose<HubProvider>((ref) => HubProvider());

class HubProvider extends ChangeNotifier {
  // Fetched Hubs
  List<HubModel> storedHubs = <HubModel>[];

  // Hubs with applicated filters
  List<HubModel> hubs = <HubModel>[];

  String userToken = "";
  String messageError = "";
  String searchText = "";

  bool isLoadingHub = false;
  bool hubView = false;
  bool displayStreetView = true;
  bool displayMapView = true;
  bool displaySearch = false;

  final log = logger(HubProvider);

  // Initialisation
  HubProvider() {
    getTokenFromSharedPref().then((token) => {userToken = token, fetchHubs()});
  }

  Future<void> fetchHubs() async {
    messageError = "";
    isLoadingHub = true;

    List<HubModel> hubsRes = [];

    try {
      log.w("FETCH ALL HUBS");
      hubsRes = await HttpService.fetchHubs(userToken);
      log.w("END FETCH HUBS");
      log.w(hubsRes[0].clientName);
    } catch (e) {
      messageError = "Error loading hubs";
      log.e(e);
    }
    hubs = hubsRes;
    storedHubs = hubsRes;

    isLoadingHub = false;
    notifyListeners();
  }

  void hubsBySearch() {
    String? theSearch = searchText.toUpperCase();
    if (searchText == "") {
      hubs = storedHubs;
    } else {
      hubs = storedHubs
          .where(
              (element) => element.groupName!.toUpperCase().contains(theSearch))
          .toList();
    }

    notifyListeners();
  }

  HubModel getHubFromMarker(Marker marker) {
    HubModel hub = hubs.firstWhere((hub) =>
        hub.pinModel?.latitude == marker.point.latitude &&
        hub.pinModel?.longitude == marker.point.longitude);
    return hub;
  }
}
