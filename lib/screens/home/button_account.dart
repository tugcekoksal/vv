// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controllers
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/screens/views/login_view.dart';
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/services/http_service.dart';

class ButtonAccount extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  String password = "";

  ButtonAccount({Key? key}) : super(key: key);

  Widget _buildDeconnexionDialog(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: (() => Navigator.pop(context)),
            child: Container(
              color: global_styles.black75,
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(loginController.userName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                        ]),
                    const SizedBox(height: 100),
                    GestureDetector(
                        onTap: () => {
                              loginController.logoutUser(),
                              Navigator.pop(context)
                            },
                        child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(15, 255, 255, 255),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.logout,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Text("Se déconnecter",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ]))),
                    const SizedBox(height: 100),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Attention ! Cette action est définitive",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: BuildInputLogin(
                                  keyLabel: "",
                                  placeholder: "Mot de passe",
                                  isPassword: true,
                                  onChanged: (value) {
                                    password = value;
                                  })),
                          const SizedBox(height: 10),
                          GestureDetector(
                              onTap: () => {
                                    HttpService.deleteUser(
                                            loginController.userToken, password)
                                        .then((value) {
                                      loginController.logoutUser();
                                      Navigator.pop(context);
                                    }).catchError((onError) {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierColor: global_styles.black75,
                                          builder: (BuildContext context) {
                                            return Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  onError,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Attention supprimer son compte est définitif !",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ));
                                          });
                                    })
                                  },
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          15, 255, 255, 255),
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: const Text("Supprimer mon compte",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))))
                        ]),
                  ])),
            )));
  }

  void displayPopUp(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => _buildDeconnexionDialog(context));
  }

  @override
  Widget build(BuildContext context) {
    return TopButton(
        actionFunction: () => {displayPopUp(context)},
        isLoading: false,
        iconButton: Icons.person);
  }
}
