// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controllers
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';

// Models
import 'package:velyvelo/models/map/map_model.dart';

//DATE FORMAT
import 'package:intl/intl.dart';
// Services
import 'package:velyvelo/services/http_service.dart';

final bikesProvider =
    ChangeNotifierProvider.autoDispose<BikesProvider>((ref) => BikesProvider());

class BikesProvider extends ChangeNotifier {
  List<MapModel> bikeList = <MapModel>[];
  List<MapModel> bikeWithPositionList = <MapModel>[];

  String userToken = "";
  String messageError = "";
  String searchText = "";

  // Loading
  bool isLoadingBikes = false;
  bool isLoadingFilters = false;

  bool didNotFoundBikesWithPosition = false;
  bool displaySearch = false;
  bool hasAccesGroups = false;
  bool hasAccesStatus = false;
  bool isFiltersChanged = false;

  // Filters
  List<String> availableFiltersList = <String>["Chargement des filtres"];
  List<String> selectedFiltersList = <String>[];
  List<String> oldSelectedFiltersList = <String>[];
  // Status
  List<String> availableStatus = <String>["Rangés", "Utilisés", "Volés"];
  List<String> selectedStatusList = <String>[];
  List<String> oldSelectedStatusList = <String>[];

  final log = logger(BikesProvider);

  // Initialisation
  BikesProvider() {
    getTokenFromSharedPref()
        .then((token) => {userToken = token, fetchAllBikes()});
  }

  void bikesBySearch() {
    String? theSearch = searchText.toUpperCase();
    if (searchText != "") {
      bikeWithPositionList = bikeList
          .where((element) => element.name.toUpperCase().contains(theSearch))
          .toList();
    } else {
      bikeWithPositionList = bikeList;
    }
    notifyListeners();
  }

  void fetchAllBikes() async {
    messageError = '';
    try {
      isLoadingBikes = true;
      didNotFoundBikesWithPosition = false;
      List<String> listOfSelectedStatus = selectedStatusList.isEmpty
          ? ["Rangés", "Utilisés", "Volés"]
          : selectedStatusList;
      var bikes = await HttpService.fetchAllBikes(
          selectedFiltersList, listOfSelectedStatus, userToken);
      if (bikes != null) {
        bikeList = bikes;
        bikeWithPositionList = bikeList.toList();

        // Check if there's no bikes in the response
        if (bikeWithPositionList.isEmpty) {
          log.d("No Bike");
          didNotFoundBikesWithPosition = true;
        } else {
          log.d("There's at least one bike");
          // add the new bikes in list
        }
      }
      isLoadingBikes = false;
      bikesBySearch();
    } catch (e) {
      isLoadingBikes = false;
      log.d("mapController fetchAllbikes $e");
      messageError =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
    notifyListeners();
  }

  void fetchFilters() async {
    try {
      isLoadingFilters = true;

      var filters = await HttpService.fetchMapfilters(userToken);
      if (filters != null) {
        availableFiltersList = filters.groups;
        availableStatus = filters.status;
        hasAccesGroups = filters.hasAccessGroups;
        hasAccesStatus = filters.hasAccessStatus;
      }
      fetchAllBikes();
      isLoadingFilters = false;
    } catch (e) {
      log.d(e);
      messageError =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
    notifyListeners();
  }

  String buildPopUpContentName(marker) {
    if (bikeWithPositionList.isEmpty) {
      return "No bikes";
    }
    MapModel bikePopup = bikeWithPositionList.firstWhere((bike) =>
        bike.pos?.latitude == marker.point.latitude &&
        bike.pos?.longitude == marker.point.longitude);
    return bikePopup.name;
  }

  MapModel getBikeFromMarker(marker) {
    MapModel theBike = bikeWithPositionList.firstWhere((bike) =>
        bike.pos?.latitude == marker.point.latitude &&
        bike.pos?.longitude == marker.point.longitude);
    return theBike;
  }

  String buildPopUpContentLastEmission(marker) {
    MapModel bikePopup = bikeWithPositionList.firstWhere((bike) =>
        bike.pos?.latitude == marker.point.latitude &&
        bike.pos?.longitude == marker.point.longitude);

    int? timeStamp = bikePopup.pos?.timestamp;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        timeStamp != null ? timeStamp * 1000 : 0);
    String result = timeStamp != null
        ? DateFormat('dd-MM-yyyy – kk:mm').format(date)
        : "Pas d'informations";
    return result;
  }

  void setFilters(value, label) {
    if (!value) {
      selectedFiltersList.remove(label);
    } else {
      selectedFiltersList.add(label);
    }

    // Know if filters has changed since last request
    isFiltersChanged = true;
    notifyListeners();
  }

  void setStatus(value, label) {
    if (!value) {
      selectedStatusList.remove(label);
    } else {
      selectedStatusList.add(label);
    }

    // Know if status has changed since last request
    isFiltersChanged = true;
    notifyListeners();
  }

  void onChangeFilters() {
    if (isFiltersChanged) {
      fetchAllBikes();
      oldSelectedFiltersList = List.from(selectedFiltersList);
      oldSelectedStatusList = List.from(selectedStatusList);
    } else {
      log.d("filters are the same");
    }
    isFiltersChanged = false;
    notifyListeners();
  }

  void toggleSearch(bool isSearch) {
    displaySearch = isSearch;
    notifyListeners();
  }
}
