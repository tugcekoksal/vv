// Vendor
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velyvelo/controllers/carte_provider/bike_filter.dart';

// Controllers
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/carte/bike_list_model.dart';
import 'package:velyvelo/models/carte/bike_map_model.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

final carteBikeProvider = ChangeNotifierProvider.autoDispose<CarteBikeProvider>(
    (ref) => CarteBikeProvider());

class CarteBikeProvider extends ChangeNotifier {
  BikeFilter filter = BikeFilter();
  ItemRefresher itemRefresher = ItemRefresher();

  List<BikeMapModel> bikeMap = <BikeMapModel>[];
  List<BikeListModel> bikeList = <BikeListModel>[];
  BikePopupModel? bikePopup;
  Marker? oldMarker;

  String userToken = "";
  String messageError = "";

  // Loading
  bool isLoadingBikes = true;

  final log = logger(CarteBikeProvider);

  // Initialisation
  CarteBikeProvider() {
    getTokenFromSharedPref()
        .then((token) => {userToken = token, fetchBikeMap()});
  }
  void cleanPopup() {
    bikePopup = null;
    notifyListeners();
  }

  // Provider functions
  void fetchBikeList() async {
    messageError = '';
    isLoadingBikes = true;
    notifyListeners();
    itemRefresher.actualize(null, null);
    try {
      List<String> listOfSelectedStatus =
          List<String>.from(filter.selectedStatusList);
      bool hasGps = true;
      if (listOfSelectedStatus.contains("Pas de gps")) {
        listOfSelectedStatus.remove("Pas de gps");
        hasGps = false;
      }
      if (listOfSelectedStatus.isEmpty) {
        listOfSelectedStatus = ["Rangé", "Utilisé", "Volé"];
      }
      bikeList = await HttpService.fetchBikeList(
          filter.selectedGroupsList,
          listOfSelectedStatus,
          filter.searchText,
          hasGps,
          itemRefresher,
          userToken);
    } catch (e) {
      log.d(e);
      messageError = e.toString();
    }
    isLoadingBikes = false;
    notifyListeners();
  }

  Future<bool> fetchNewBikeList() async {
    itemRefresher.actualize(bikeList.first.id ?? -1, bikeList.length);
    List<BikeListModel> newList = [];
    try {
      List<String> listOfSelectedStatus =
          List<String>.from(filter.selectedStatusList);
      bool hasGps = true;
      if (listOfSelectedStatus.contains("Pas de gps")) {
        listOfSelectedStatus.remove("Pas de gps");
        hasGps = false;
      }
      if (listOfSelectedStatus.isEmpty) {
        listOfSelectedStatus = ["Rangé", "Utilisé", "Volé"];
      }
      newList = await HttpService.fetchBikeList(
          filter.selectedGroupsList,
          listOfSelectedStatus,
          filter.searchText,
          hasGps,
          itemRefresher,
          userToken);
      bikeList += newList;
    } catch (e) {
      log.d(e);
      messageError = e.toString();
    }
    notifyListeners();
    return newList.isNotEmpty;
  }

  // Provider functions
  void fetchBikeMap() async {
    messageError = '';
    isLoadingBikes = true;
    notifyListeners();
    if (filter.selectedStatusList.contains("Pas de gps")) {
      filter.selectedStatusList.remove("Pas de gps");
    }
    try {
      List<String> listOfSelectedStatus = filter.selectedStatusList.isEmpty
          ? ["Rangé", "Utilisé", "Volé"]
          : filter.selectedStatusList;
      bikeMap = await HttpService.fetchBikeMap(filter.selectedGroupsList,
          listOfSelectedStatus, filter.searchText, userToken);
    } catch (e) {
      log.d(e);
      messageError = e.toString();
    }
    isLoadingBikes = false;
    notifyListeners();
  }

  void fetch(bool isList) {
    if (isList) {
      fetchBikeList();
    } else {
      fetchBikeMap();
    }
    notifyListeners();
  }

  void fetchPopupBike(Marker marker) async {
    if (marker.point == oldMarker?.point) {
      return;
    }
    oldMarker = marker;

    BikeMapModel selectBike = bikeMap.firstWhere((bike) =>
        bike.latitude == marker.point.latitude &&
        bike.longitude == marker.point.longitude);
    try {
      bikePopup =
          await HttpService.fetchBikePopup(selectBike.id ?? 0, userToken);
    } catch (e) {
      bikePopup = null;
      messageError = e.toString();
    }
  }

  BikeMapModel getBikeFromMarker(marker) {
    BikeMapModel theBike = bikeMap.firstWhere((bike) =>
        bike.latitude == marker.point.latitude &&
        bike.longitude == marker.point.longitude);
    return theBike;
  }

  // Filter functions
  void fetchFilters(bool isList) async {
    String? error = await filter.fetchFilters(userToken);
    if (isList) {
      filter.availableStatus = ["Rangé", "Utilisé", "Volé", "Pas de gps"];
    } else {
      filter.availableStatus = ["Rangé", "Utilisé", "Volé"];
    }
    if (error != null) {
      messageError = error;
    }
    notifyListeners();
  }

  void setFilters(value, label) {
    filter.setFilters(value, label);
    notifyListeners();
  }

  void setStatus(value, label) {
    filter.setStatus(value, label);
    notifyListeners();
  }

  void onChangeFilters(bool isList) {
    filter.onChangeFilters();
    if (isList) {
      fetchBikeMap();
    } else {
      fetchBikeList();
    }
    notifyListeners();
  }

  void toggleSearch(bool isSearch) {
    filter.toggleSearch(isSearch);
    notifyListeners();
  }
}
