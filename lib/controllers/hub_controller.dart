// Vendor
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

// Models
import 'package:velyvelo/models/bike/user_bike_model.dart';
import 'package:velyvelo/models/hubs/hub_map.dart';
import 'package:velyvelo/screens/views/my_bikes/pin.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

class HubController extends GetxController {
  var userToken;
  var hubView = false.obs;

  RxList<HubModel> hubs = <HubModel>[].obs;

  var isLoadingHub = false.obs;
  var error = ''.obs;

  var isStreetView = true;

  var isMapView = true;
  // var hubPopUpInfos = HubModel().obs;

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
      print(hubsRes);
      print("OGEUWHHHHHHHHH");
      if (hubsRes != null) {
        hubs.value = hubsRes;
        print(hubs);
      } else {
        print("Error loading hubs data.");
      }
      isLoadingHub.value = false;
    } catch (e) {
      print(e);
    }
  }

  // Future<void> fetchOneHub(int groupPk) async {
  //   error.value = "";
  //   try {
  //     var hubRes = await HttpService.fetchOneHub(groupPk, userToken);
  //     if (hubRes != null) {
  //       hubPopUpInfos.value = hubRes;
  //     } else {
  //       print("Error loading hubs data.");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  HubModel getHubFromMarker(Marker marker) {
    HubModel hub = hubs.firstWhere((hub) =>
        hub.pinModel?.latitude == marker.point.latitude &&
        hub.pinModel?.longitude == marker.point.longitude);
    return hub;
  }
}
