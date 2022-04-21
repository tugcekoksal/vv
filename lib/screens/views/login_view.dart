// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(alignment: Alignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.08),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Bienvenue !",
                      style: TextStyle(
                          color: GlobalStyles.purple,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w700)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Connectez-vous à votre espace VelyVelo",
                      style: TextStyle(
                          color: GlobalStyles.purple,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: screenHeight * 0.06),
                Obx(() {
                  if (loginController.isLoading.value) {
                    return CircularProgressIndicator();
                  } else {
                    return SizedBox();
                  }
                }),
                BuildInputLogin(
                    placeholder: "Identifiant",
                    isPassword: false,
                    onChanged: loginController.onChangedLogin),
                SizedBox(height: 10.0),
                BuildInputLogin(
                    placeholder: "Mot de passe",
                    isPassword: true,
                    onChanged: loginController.onChangedPassword),
                SizedBox(height: 5.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => launch(
                        'https://dms.velyvelo.com/accounts/password/reset/'),
                    child: Text("Mot de passe oublié ?",
                        style: TextStyle(
                            color: GlobalStyles.purple,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: AnimatedOpacity(
                        opacity: loginController.error.value != "" ? 1 : 0,
                        duration: Duration(milliseconds: 300),
                        child: Text(loginController.error.value,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500))),
                  );
                }),
                SizedBox(height: screenHeight * 0.05),
                GestureDetector(
                  onTap: () => loginController.loginUser(),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
                    decoration: BoxDecoration(
                        color: GlobalStyles.purple,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Text('Se connecter',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700)),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
                width: screenWidth,
                child: Image.asset(
                  "assets/background-login.png",
                  fit: BoxFit.fill,
                )),
          ),
          Positioned(
            bottom: screenWidth * 0.45,
            child: InkWell(
              onTap: () => launch('https://dms.velyvelo.com/signup_apple/'),
              child: Text(
                  "Vous n'avez pas encore de compte chez nous ? Cliquez ici",
                  style: TextStyle(
                      color: GlobalStyles.purple,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ]));
  }
}

class BuildInputLogin extends StatefulWidget {
  final String placeholder;
  final bool isPassword;
  final Function onChanged;
  BuildInputLogin(
      {Key? key,
      required this.placeholder,
      required this.isPassword,
      required this.onChanged})
      : super(key: key);

  @override
  _BuildInputLoginState createState() => _BuildInputLoginState();
}

class _BuildInputLoginState extends State<BuildInputLogin> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      obscureText: widget.isPassword ? _isObscure : false,
      autofocus: false,
      onChanged: (e) => widget.onChanged(e),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: widget.placeholder,
        hintStyle: TextStyle(
            color: GlobalStyles.greyLogin,
            fontSize: 12.0,
            fontWeight: FontWeight.w700),
        contentPadding:
            const EdgeInsets.only(left: 20.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                color: GlobalStyles.purple,
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : SizedBox(),
      ),
    );
  }
}
