// Vendor
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  final refreshController = RefreshController();

  var bikeList = <MapModel>[];
  var bikeWithPositionList = <MapModel>[].obs;
  var didNotFoundBikesWithPosition = false.obs;

  var hasAccesGroups = false.obs;
  var hasAccesStatus = false.obs;

  var availableFiltersList = ["Chargement des filtres"].obs;
  var selectedFiltersList = [].obs;
  var oldSelectedFiltersList = [];

  var availableStatus = ["Rangés", "Utilisés", "Volés"].obs;
  var selectedStatusList = <String>[].obs;
  var oldSelectedStatusList = [];

  var isFiltersChanged = false.obs;

  var error = ''.obs;

  var isMapView = true;

  var searchText = "".obs;
  var displaySearch = false.obs;

  var isStreetView = true;

  void changeMapView() {
    isMapView = !isMapView;
  }

  void changeMapStyle() {
    isStreetView = !isStreetView;
  }

  void bikesBySearch() {
    String? theSearch = searchText.value.capitalize;
    if (searchText.value != "") {
      bikeWithPositionList.value = bikeList
          .where((element) => element.name.capitalize!.contains(theSearch!))
          .toList();
      bikeWithPositionList.refresh();
    } else {
      bikeWithPositionList.value = bikeList;
    }
  }

  void fetchAllBikes() async {
    error.value = '';
    try {
      isLoading(true);
      didNotFoundBikesWithPosition(false);
      List<String> listOfSelectedStatus = selectedStatusList.isEmpty
          ? ["Rangés", "Utilisés", "Volés"]
          : selectedStatusList;
      var bikes = await HttpService.fetchAllBikes(
          selectedFiltersList, listOfSelectedStatus, userToken);
      if (bikes != null) {
        bikeList = bikes;
        bikeWithPositionList.value = bikeList.toList();
        bikeWithPositionList.refresh();

        // Check if there's no bikes in the response
        if (bikeWithPositionList.isEmpty) {
          print("No Bike");
          didNotFoundBikesWithPosition(true);
        } else {
          print("There's at least one bike");
          // add the new bikes in list
        }
      }
      isLoading(false);
      bikesBySearch();
    } catch (e) {
      isLoading(false);
      print("mapController fetchAllbikes $e");
      error.value =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
  }

  void fetchFilters() async {
    try {
      isLoadingFilters(true);

      var filters = await HttpService.fetchMapfilters(userToken);
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

  String? buildPopUpContentName(marker) {
    MapModel? bikePopup = bikeWithPositionList.firstWhereOrNull((bike) =>
        bike.pos?.latitude == marker.point.latitude &&
        bike.pos?.longitude == marker.point.longitude);
    if (bikePopup == null) return null;
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
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        timeStamp != null ? timeStamp * 1000 : 0);
    String result = timeStamp != null
        ? DateFormat('dd-MM-yyyy – kk:mm').format(date)
        : "Pas d'informations";
    return result;
  }

  void setBikeToNewRobbedStatus(marker) async {
    MapModel bikePopup = bikeWithPositionList.firstWhere((bike) =>
        bike.pos?.latitude == marker.point.latitude &&
        bike.pos?.longitude == marker.point.longitude);
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
    isFiltersChanged(true);
  }

  void setStatus(value, label) {
    if (!value) {
      selectedStatusList.remove(label);
    } else {
      selectedStatusList.add(label);
    }

    // Know if status has changed since last request
    isFiltersChanged(true);
  }

  void onChangeFilters() {
    if (isFiltersChanged.value) {
      fetchAllBikes();
      oldSelectedFiltersList = List.from(selectedFiltersList);
      oldSelectedStatusList = List.from(selectedStatusList);
    } else {
      print("filters are the same");
    }
    isFiltersChanged(false);
  }
}
