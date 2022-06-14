// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velyvelo/controllers/carte_provider/bike_filter.dart';

// Controllers
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/carte/bike_map_model.dart';
import 'package:velyvelo/models/carte/hub_list_model.dart';
import 'package:velyvelo/models/carte/hub_map_model.dart';

// Models
import 'package:velyvelo/models/map/map_model.dart';

//DATE FORMAT
import 'package:intl/intl.dart';
// Services
import 'package:velyvelo/services/http_service.dart';

final carteHubProvider = ChangeNotifierProvider.autoDispose<CarteHubProvider>(
    (ref) => CarteHubProvider());

class CarteHubProvider extends ChangeNotifier {
  List<HubMapModel> hubMap = <HubMapModel>[];
  List<HubListModel> hubList = <HubListModel>[];
  HubListModel? hubPopup;

  Marker? oldMarker;

  String userToken = "";
  String messageError = "";
  String searchText = "";

  bool isLoadingHub = true;
  bool displaySearch = false;

  final log = logger(CarteHubProvider);

  // Initialisation
  CarteHubProvider() {
    getTokenFromSharedPref()
        .then((token) => {userToken = token, fetchHubMap()});
  }

  void cleanPopup() {
    hubPopup = null;
    notifyListeners();
  }

  Future<void> fetchHubList() async {
    messageError = "";
    isLoadingHub = true;

    List<HubListModel> hubsRes = [];

    try {
      hubsRes = await HttpService.fetchHubList(searchText, userToken);
    } catch (e) {
      messageError = "Error loading hubs";
      log.e(e.toString());
    }
    hubList = hubsRes;
    isLoadingHub = false;
    notifyListeners();
  }

  Future<void> fetchHubMap() async {
    messageError = "";
    isLoadingHub = true;

    List<HubMapModel> hubsRes = [];

    try {
      hubsRes = await HttpService.fetchHubMap(searchText, userToken);
    } catch (e) {
      messageError = "Error loading hubs";
      log.e(e.toString());
    }
    hubMap = hubsRes;
    isLoadingHub = false;
    notifyListeners();
  }

  void fetch(bool isList) {
    if (isList) {
      fetchHubList();
    } else {
      fetchHubMap();
    }
    notifyListeners();
  }

  void fetchPopupHub(Marker marker) async {
    if (marker.point == oldMarker?.point) {
      return;
    }
    oldMarker = marker;
    print("fetchhu");

    HubMapModel selectedHub = hubMap.firstWhere((hub) =>
        hub.latitude == marker.point.latitude &&
        hub.longitude == marker.point.longitude);
    try {
      hubPopup =
          await HttpService.fetchHubPopup(selectedHub.id ?? -1, userToken);
    } catch (e) {
      hubPopup = null;
      messageError = e.toString();
      log.e(messageError);
    }
  }

  HubMapModel getHubFromMarker(Marker marker) {
    HubMapModel hub = hubMap.firstWhere((hub) =>
        hub.latitude == marker.point.latitude &&
        hub.longitude == marker.point.longitude);
    return hub;
  }

  void toggleSearch(bool isSearch) {
    displaySearch = isSearch;
    notifyListeners();
  }
}
