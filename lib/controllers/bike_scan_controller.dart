// Vendor
import 'package:get/get.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

// Models
import 'package:velyvelo/models/bike/bike_model.dart';

class BikeScanController extends GetxController {
  String userToken = Get.find<LoginController>().userToken;
  var isLoading = true.obs;
  var bikeById = BikeModel().obs;
  var isBikeIncidentsOpen = false.obs;

  @override
  void onInit() {
    // fetchIncidentById(5);
    super.onInit();
  }

  toggleIsBikeIncidentsOpen() {
    isBikeIncidentsOpen.value = !isBikeIncidentsOpen.value;
  }
}
