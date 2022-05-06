// Vendor
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';
import 'package:velyvelo/controllers/bike_scan_controller.dart';
import 'package:velyvelo/controllers/hub_controller.dart';
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/controllers/navigation_controller.dart';

// Models
import 'package:velyvelo/models/bike/user_bike_model.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var login = ''.obs;
  var password = ''.obs;

  var isLogin = false.obs;
  var isClient = false.obs;
  var isUser = false.obs;
  var isAdminOrTech = false.obs;
  var isSuperUser = false.obs;
  var isTech = false.obs;

  var userToken = "";
  String userName = "";

  var userType = "";

  var userBikeID = 0.obs;
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

  var error = "".obs;

  @override
  void onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("username") != null &&
        prefs.getString("token") != null) {
      isLoading(false);
      isLogin(true);
      tokenAndNameAuth();
    }
  }

  void tokenAndNameAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") != null) {
      userToken = prefs.getString("token")!;
      fetchTypeUser();
      isLogin(true);
      await HttpService.addDeviceToken(userToken);
    }
    if (prefs.getString("username") != null) {
      userName = prefs.getString("username")!;
    }
  }

  void onChangedPassword(value) {
    password.value = value;
  }

  void onChangedLogin(value) async {
    login.value = value;
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', value);
  }

  // Login the user with login and password
  Future loginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    error.value = "";
    try {
      isLoading(true);
      // Call the login function
      var token = await HttpService.loginUser(login.value, password.value);
      userToken = token;
      userName = userName = prefs.getString("username")!;
      await prefs.setString('token', userToken);
      print(token);
      isLoading(false);
      isLogin(true);
      fetchTypeUser();
      tokenAndNameAuth();
    } catch (e) {
      print(e);
      error.value = "Identifiants ou mot de passe incorrects";
    }
  }

  void logoutUser() async {
    isLogin(false);

    isClient(false);
    isUser(false);
    isSuperUser(false);
    isAdminOrTech(false);
    isTech(false);

    userToken = "";
    userType = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove("username");

    Get.delete<IncidentController>();
    Get.delete<BikeController>();
    Get.delete<BikeScanController>();
    Get.delete<HubController>();
    Get.delete<MapBikesController>();
    Get.delete<IncidentDeclarationController>();

    NavigationController navigationController = Get.put(NavigationController());
    navigationController.currentIndex.value = 0;
  }

  void fetchTypeUser() async {
    try {
      var userTypeFetched = await HttpService.fetchTypeUser(userToken);

      if (userTypeFetched == "Client") {
        isClient(true);
        userType = "Client";
      } else if (userTypeFetched == "Utilisateur") {
        isUser(true);
        userType = "User";
        fetchBikeIDIfUser();
      } else if (userTypeFetched == "SuperUser") {
        isSuperUser(true);
        userType = "SuperUser";
      } else if (userTypeFetched == "Admin" ||
          userTypeFetched == "Technicien") {
        isAdminOrTech(true);
        userType = "AdminOrTechnician";
        if (userTypeFetched == "Technicien") {
          isTech(true);
        }
      }
      isLogin(true);
    } catch (e) {
      print(e);
    }
  }

  void fetchBikeIDIfUser() async {
    try {
      isLoading(true);
      var bikeID = await HttpService.fetchBikeIDUser(userToken);
      if (bikeID != null) {
        userBikeID.value = bikeID[0].veloPk;

        // Get the bike of the user
        Get.find<BikeController>().fetchUserBike(userBikeID.value);
      }
      isLoading(false);
    } catch (e) {
      print(e);
    }
  }
}
