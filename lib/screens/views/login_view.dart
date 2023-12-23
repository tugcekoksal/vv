// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:velyvelo/controllers/navigation_controller.dart';
import 'package:velyvelo/screens/home/connexion_status.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController loginController = Get.put(LoginController());
  final NavigationController navigationController =
      Get.put(NavigationController());
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    const snackBarLoading = SnackBar(
        content: Text('Connexion en cours...'),
        backgroundColor: global_styles.blue);

    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
            bottom: 0,
            width: screenWidth,
            child: Image.asset(
              "assets/background-login.png",
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.2),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Bienvenue !",
                      style: TextStyle(
                          color: global_styles.purple,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w700)),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Connectez-vous à votre espace VelyVelo",
                      style: TextStyle(
                          color: global_styles.purple,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(height: screenHeight * 0.03),
                BuildInputLogin(
                    keyLabel: "login-username",
                    placeholder: "Identifiant",
                    isPassword: false,
                    onChanged: loginController.onChangedLogin),
                const SizedBox(height: 10.0),
                BuildInputLogin(
                    keyLabel: "login-password",
                    placeholder: "Mot de passe",
                    isPassword: true,
                    onChanged: loginController.onChangedPassword),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => launchUrl(Uri.parse(
                            'https://dms.velyvelo.com/delete_account/')),
                        child: const Text("Supprimer mon compte",
                            style: TextStyle(
                                color: global_styles.orange,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => launchUrl(Uri.parse(
                            'https://dms.velyvelo.com/accounts/password/reset/')),
                        child: const Text("Mot de passe oublié ?",
                            style: TextStyle(
                                color: global_styles.purple,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: AnimatedOpacity(
                        opacity: loginController.error.value != "" ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Text(loginController.error.value,
                            key: const Key("login-error"),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500))),
                  );
                }),
                SizedBox(height: screenHeight * 0.03),
                GestureDetector(
                  key: const Key("login-button"),
                  onTap: () async => {
                    ScaffoldMessenger.of(context).showSnackBar(snackBarLoading),
                    await loginController.loginUser(),
                    ScaffoldMessenger.of(context).clearSnackBars(),
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 14.0),
                    decoration: BoxDecoration(
                        color: global_styles.purple,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: const Text('Se connecter',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                InkWell(
                  onTap: () => launchUrl(
                      Uri.parse('https://dms.velyvelo.com/signup_apple/')),
                  child: const Text(
                      "Vous n'avez pas encore de compte chez nous ? Cliquez ici",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: global_styles.purple,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/logo.png",
                      height: 50,
                      width: 50,
                    )),
              )),
          Positioned(
              width: screenWidth,
              height: 100,
              left: 0,
              top: 0,
              child: const Padding(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Velyvelo",
                              style: TextStyle(
                                  color: global_styles.backgroundDarkGrey,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w700),
                            )
                          ])
                    ],
                  ))),
          const ConnexionStatus(),
        ]));
  }
}

class BuildInputLogin extends StatefulWidget {
  final String placeholder;
  final bool isPassword;
  final Function onChanged;
  final String keyLabel;

  const BuildInputLogin(
      {super.key,
      required this.keyLabel,
      required this.placeholder,
      required this.isPassword,
      required this.onChanged});

  @override
  _BuildInputLoginState createState() => _BuildInputLoginState();
}

class _BuildInputLoginState extends State<BuildInputLogin> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 100,
      key: Key(widget.keyLabel),
      autocorrect: false,
      obscureText: widget.isPassword ? _isObscure : false,
      autofocus: false,
      onChanged: (e) => {widget.onChanged(e)},
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        hintText: widget.placeholder,
        hintStyle: const TextStyle(
            color: global_styles.greyLogin,
            fontSize: 12.0,
            fontWeight: FontWeight.w700),
        contentPadding:
            const EdgeInsets.only(left: 20.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                color: global_styles.purple,
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
