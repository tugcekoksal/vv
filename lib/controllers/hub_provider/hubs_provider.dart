// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controllers
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';

// Models
import 'package:velyvelo/models/hubs/hub_map.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

final hubsProvider =
    ChangeNotifierProvider.autoDispose<HubsProvider>((ref) => HubsProvider());

class HubsProvider extends ChangeNotifier {
  // Fetched Hubs
  List<HubModel> storedHubs = <HubModel>[];

  // Hubs with applicated filters
  List<HubModel> hubs = <HubModel>[];

  String userToken = "";
  String messageError = "";
  String searchText = "";

  bool isLoadingHub = false;
  bool displaySearch = false;

  final log = logger(HubsProvider);

  // Initialisation
  HubsProvider() {
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

  void toggleSearch(bool isSearch) {
    displaySearch = isSearch;
    notifyListeners();
  }
}
