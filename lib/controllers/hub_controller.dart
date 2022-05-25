// Vendor
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

// Models
import 'package:velyvelo/models/hubs/hub_map.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

class HubController extends GetxController {
  String userToken = "";
  var hubView = false.obs;
  final refreshController = RefreshController();

  RxList<HubModel> hubs = <HubModel>[].obs;
  List<HubModel> storedHubs = <HubModel>[];

  var isLoadingHub = false.obs;
  var error = ''.obs;

  var isStreetView = true;

  var isMapView = true;
  // var hubPopUpInfos = HubModel().obs;
  RxBool displaySearch = false.obs;
  RxString searchText = "".obs;

  void changeMapView() {
    isMapView = !isMapView;
  }

  void changeMapStyle() {
    isStreetView = !isStreetView;
  }

  @override
  void onInit() {
    userToken = Get.find<LoginController>().userToken;
    super.onInit();
  }

  Future<void> fetchHubs() async {
    error.value = "";
    isLoadingHub.value = true;
    try {
      var hubsRes = await HttpService.fetchHubs(userToken);
      if (hubsRes != null) {
        hubs.value = hubsRes;
        storedHubs = hubsRes;
      } else {
        error.value = "Error loading hubs";
        print("Error loading hubs data.");
      }
      isLoadingHub.value = false;
    } catch (e) {
      isLoadingHub.value = false;
      error.value = "Error loading hubs";
      print(e);
    }
  }

  void hubsBySearch() {
    String? theSearch = searchText.value.toUpperCase();
    if (searchText.value != "") {
      hubs.value = storedHubs
          .where(
              (element) => element.groupName!.capitalize!.contains(theSearch!))
          .toList();
      hubs.refresh();
    } else {
      hubs.value = storedHubs;
    }
  }

  HubModel getHubFromMarker(Marker marker) {
    HubModel hub = hubs.firstWhere((hub) =>
        hub.pinModel?.latitude == marker.point.latitude &&
        hub.pinModel?.longitude == marker.point.longitude);
    return hub;
  }
}
