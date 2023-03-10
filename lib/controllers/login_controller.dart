// Vendor
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controllers
import 'package:velyvelo/controllers/bike_scan_controller.dart';
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/navigation_controller.dart';
import 'package:velyvelo/helpers/logger.dart';

// Models
import 'package:velyvelo/models/bike/user_bike_model.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

class LoginController extends GetxController {
  final log = logger(LoginController);

  var isLoading = false.obs;
  var login = ''.obs;
  var password = ''.obs;

  var isLogged = false.obs;
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
      isLogged(true);
      tokenAndNameAuth();
    }
  }

  void tokenAndNameAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") != null) {
      userToken = prefs.getString("token")!;
      fetchTypeUser();
      isLogged(true);
      await HttpService.addDeviceToken(userToken);
    }
    if (prefs.getString("username") != null) {
      userName = prefs.getString("username")!;
    }
  }

  void setUsername(SharedPreferences prefs, String? name) async {
    if (name != null) {
      await prefs.setString('username', name);
      userName = name;
    } else {
      userName = prefs.getString("username") ?? "No user";
    }
  }

  void setToken(SharedPreferences prefs, String? token) async {
    if (token != null) {
      await prefs.setString('token', token);
      userToken = token;
    } else {
      userToken = prefs.getString("token") ?? "No token";
    }
  }

  void setTypeUser(SharedPreferences prefs, String? typeUser) async {
    if (typeUser != null) {
      await prefs.setString('typeUser', typeUser);
      userType = typeUser;
    } else {
      userType = prefs.getString("typeUser") ?? "No type user";
    }
  }

  // Login the user with login and password
  Future loginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    error.value = "";
    isLoading(true);

    // Get login token or stop
    String token;
    try {
      token = await HttpService.loginUser(login.value, password.value);
    } catch (e) {
      log.e(e.toString());
      error.value = e.toString();
      return;
    }

    // Update shared preferences
    setUsername(prefs, login.value);
    setToken(prefs, token);

    fetchTypeUser();
    tokenAndNameAuth();
    isLoading(false);
    isLogged(true);
  }

  void logoutUser() async {
    isLogged(false);

    isClient(false);
    isUser(false);
    isSuperUser(false);
    isAdminOrTech(false);
    isTech(false);

    userToken = "";
    userType = "";
    login.value = "";
    password.value = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove("username");

    Get.delete<IncidentController>();
    Get.delete<BikeScanController>();
    Get.delete<IncidentDeclarationController>();

    NavigationController navigationController = Get.put(NavigationController());
    navigationController.currentIndex.value = 0;
  }

  void fetchTypeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userTypeFetched;

    // Fetch type user, if no connexion try get the last user type in prefs
    try {
      userTypeFetched = await HttpService.fetchTypeUser(userToken);
    } catch (e) {
      log.e(e.toString());
      userTypeFetched = prefs.getString("typeUser") ?? "";
    }

    if (userTypeFetched == "Client") {
      isClient(true);
      setTypeUser(prefs, "Client");
    } else if (userTypeFetched == "Utilisateur") {
      isUser(true);
      setTypeUser(prefs, "User");
    } else if (userTypeFetched == "SuperUser") {
      isSuperUser(true);
      setTypeUser(prefs, "SuperUser");
    } else if (userTypeFetched == "Admin" || userTypeFetched == "Technicien") {
      isAdminOrTech(true);
      setTypeUser(prefs, "AdminOrTechnician");
      if (userTypeFetched == "Technicien") {
        setTypeUser(prefs, "Technicien");
        isTech(true);
      }
    } else {
      isLogged.value = false;
      return;
    }
    isLogged(true);
  }

  void onChangedPassword(value) {
    password.value = value;
  }

  void onChangedLogin(value) async {
    login.value = value;
  }
}
