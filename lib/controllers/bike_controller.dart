// Vendor
import 'package:get/get.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

// Models
import 'package:velyvelo/models/bike/user_bike_model.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

class BikeController extends GetxController {
  var userToken;
  var userBikeID;

  var isViewingScanPage = false.obs;

  var isLoading = true.obs;
  var isBikeIncidentsOpen = false.obs;

  var userBike = UserBikeModel(
      clientName: "",
      numeroCadran: "",
      kilometrage: 0.0,
      dateCreation: "",
      pictureUrl: "",
      groupeName: "",
      isStolen: false,
      bikeName: "",
      veloPk: 0,
      otherRepairs: [],
      inProgressRepairs: []).obs;

  var error = ''.obs;

  @override
  void onInit() {
    userToken = Get.find<LoginController>().userToken;
    super.onInit();
  }

  Future<void> fetchUserBike(int veloPk) async {
    try {
      isLoading(true);
      var bike = await HttpService.fetchUserBike(veloPk, userToken);
      if (bike != null) {
        userBike.value = bike;
        isLoading(false);
      }
    } catch (e) {
      print(e);
      error.value =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
  }

  toggleIsBikeIncidentsOpen() {
    isBikeIncidentsOpen.value = !isBikeIncidentsOpen.value;
  }

  Future setBikeToNewRobbedStatus(bool isRobbed, int veloPk) async {
    try {
      var bikeRobbed =
          await HttpService.setBikeRobbed(veloPk, isRobbed, userToken);
      if (bikeRobbed != null) {
        print(bikeRobbed);
      }
    } catch (e) {
      print(e);
    }
  }
}
