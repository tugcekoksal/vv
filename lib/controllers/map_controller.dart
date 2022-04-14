// Vendor
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

// Models
import 'package:velyvelo/models/map/map_model.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

//DATE FORMAT
import 'package:intl/intl.dart';

class MapBikesController extends GetxController {
  String userToken = Get.find<LoginController>().userToken;
  var isLoading = false.obs;
  var isLoadingFilters = false.obs;

  var bikeList = <MapModel>[];
  var bikeWithPositionList = [].obs;
  var didNotFoundBikesWithPosition = false.obs;

  var hasAccesGroups = false.obs;
  var hasAccesStatus = false.obs;

  var availableFiltersList = ["Chargement des filtres"].obs;
  var selectedFiltersList = [].obs;
  var oldSelectedFiltersList = [];

  var availableStatus = ["Rangés", "Utilisés", "Volés"].obs;
  var selectedStatus = "Utilisés".obs;
  var oldSelectedStatus = "Utilisés";

  var isFiltersChanged = false.obs;
  var isStatusChanged = false.obs;

  var error = ''.obs;

  @override
  void onInit() {
    fetchFilters();
    super.onInit();
  }

  void fetchAllBikes() async {
    error.value = '';
    try {
      isLoading(true);
      didNotFoundBikesWithPosition(false);
      var bikes = await HttpService.fetchAllBikes(
          selectedFiltersList, selectedStatus.value, userToken);
      if (bikes != null) {
        bikeList = bikes;
        bikeWithPositionList.value =
            bikeList.where((bike) => bike.pos!.message == null).toList();
        bikeWithPositionList.refresh();

        // Check if there's no bikes in the response
        if (bikeWithPositionList.length == 0) {
          print("No Bike");
          didNotFoundBikesWithPosition(true);
        } else {
          print("There's at least one bike");
          // add the new bikes in list
        }
      }
      isLoading(false);
    } catch (e) {
      print("mapController fetchAllbikes $e");
      error.value =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
  }

  void fetchFilters() async {
    try {
      isLoadingFilters(true);
      var filters = await HttpService.fetchMapfilters(userToken);
      print(filters);
      if (filters != null) {
        availableFiltersList.value = filters.groups;
        availableStatus.value = filters.status;
        hasAccesGroups.value = filters.hasAccessGroups;
        hasAccesStatus.value = filters.hasAccessStatus;
      }
      fetchAllBikes();
      isLoadingFilters(false);
    } catch (e) {
      print(e);
      error.value =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
  }

  String buildPopUpContentName(marker) {
    MapModel bikePopup = bikeWithPositionList.firstWhere((bike) =>
        bike.pos.latitude == marker.point.latitude &&
        bike.pos.longitude == marker.point.longitude);
    return bikePopup.name;
  }

  String buildPopUpContentLastEmission(marker) {
    MapModel bikePopup = bikeWithPositionList.firstWhere((bike) =>
        bike.pos.latitude == marker.point.latitude &&
        bike.pos.longitude == marker.point.longitude);

    int? timeStamp = bikePopup.pos?.timestamp;
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        timeStamp != null ? timeStamp * 1000 : 0);
    print("cocoucuc");
    print(bikePopup.name);
    print(timeStamp);
    print(date);
    String result = timeStamp != null
        ? DateFormat('dd-MM-yyyy – kk:mm').format(date)
        : "Pas d'informations";
    return result;
  }

  void setBikeToNewRobbedStatus(marker) async {
    MapModel bikePopup = bikeWithPositionList.firstWhere((bike) =>
        bike.pos.latitude == marker.point.latitude &&
        bike.pos.longitude == marker.point.longitude);
    try {
      // isLoading(true);
      var bikeRobbed =
          await HttpService.setBikeRobbed(bikePopup.veloPk, true, userToken);
      // isLoading(false);
      if (bikeRobbed != null) {
        print(bikeRobbed);
      }
    } catch (e) {
      print(e);
    }
  }

  void setFilters(value, label) {
    if (!value) {
      selectedFiltersList.remove(label);
    } else {
      selectedFiltersList.add(label);
    }

    // Know if filters has changed since last request
    if (listEquals(oldSelectedFiltersList, selectedFiltersList) == false) {
      isFiltersChanged(true);
    } else {
      isFiltersChanged(false);
    }
  }

  void setStatus(value, label) {
    if (value) {
      selectedStatus.value = label;
    } else {
      selectedStatus.value = "";
    }

    // Know if status has changed since last request
    if (oldSelectedStatus != selectedStatus.value) {
      isStatusChanged(true);
    } else {
      isStatusChanged(false);
    }
  }

  void onChangeFilters() {
    if (isFiltersChanged.value || isStatusChanged.value) {
      fetchAllBikes();
      print("filters has changed");
      oldSelectedFiltersList = List.from(selectedFiltersList);
      oldSelectedStatus = selectedStatus.value;
    } else {
      print("filters are the same");
    }
  }
}
