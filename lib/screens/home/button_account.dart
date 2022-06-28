// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controllers
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;

class ButtonAccount extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  ButtonAccount({Key? key}) : super(key: key);

  Widget _buildDeconnexionDialog(BuildContext context) {
    return GestureDetector(
        onTap: (() => Navigator.pop(context)),
        child: Container(
          color: global_styles.black75,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    onTap: () =>
                        {loginController.logoutUser(), Navigator.pop(context)},
                    child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(15, 255, 255, 255),
                            border: Border.all(color: Colors.white, width: 1),
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
                            ])))
              ])),
        ));
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
