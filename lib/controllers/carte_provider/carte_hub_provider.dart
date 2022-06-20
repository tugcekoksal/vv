// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controllers
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/carte/hub_list_model.dart';
import 'package:velyvelo/models/carte/hub_map_model.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

final carteHubProvider = ChangeNotifierProvider.autoDispose<CarteHubProvider>(
    (ref) => CarteHubProvider());

class CarteHubProvider extends ChangeNotifier {
  ItemRefresher itemRefresher = ItemRefresher();

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
    itemRefresher.actualize(null, null);
    try {
      hubsRes =
          await HttpService.fetchHubList(searchText, itemRefresher, userToken);
      hubList = hubsRes;
    } catch (e) {
      messageError = "Error loading hubs";
      log.e(e.toString());
    }
    isLoadingHub = false;
    notifyListeners();
  }

  Future<bool> fetchNewHubList() async {
    messageError = "";

    List<HubListModel> hubsRes = [];
    itemRefresher.actualize(hubList.first.id ?? -1, hubList.length);
    try {
      hubsRes =
          await HttpService.fetchHubList(searchText, itemRefresher, userToken);
      hubList += hubsRes;
    } catch (e) {
      messageError = "Error loading hubs";
      log.e(e.toString());
    }
    notifyListeners();
    return hubsRes.isNotEmpty;
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
