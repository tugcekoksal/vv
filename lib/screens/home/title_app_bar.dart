// Vendor
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/screens/home/button_account.dart';

// Views
import 'package:velyvelo/screens/views/incidents_view/incidents_view.dart';
import 'package:velyvelo/screens/views/login_view.dart';
import 'package:velyvelo/screens/views/my_bikes/my_bikes_view.dart';
import 'package:velyvelo/screens/views/incidents_declaration.dart';

//Controllers
import 'package:velyvelo/controllers/navigation_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

class TitleAppBar extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final String title;
  final bool onTransparentBackground;
  final List<String> tabTitleUser = ["Mes incidents", "Mes vélos", "Mon vélo"];

  TitleAppBar(
      {Key? key, required this.onTransparentBackground, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: onTransparentBackground
          ? Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(100)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loginController.isLogin.value ? title : "VelyVelo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: GlobalStyles.backgroundDarkGrey,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700),
                    )
                  ]))
          : Text(
              loginController.isLogin.value ? title : "VelyVelo",
              style: TextStyle(
                  color: GlobalStyles.backgroundDarkGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            ),
    );
  }
}

class SubTitleIncidents extends StatelessWidget {
  final IncidentController incidentController;

  const SubTitleIncidents({Key? key, required this.incidentController})
      : super(key: key);
  String getSubtitleIncident() {
    int count = 0;

    count += incidentController.incidentFilters.contains("Nouvelle") ? 1 : 0;
    count += incidentController.incidentFilters.contains("En cours") ? 1 : 0;
    count += incidentController.incidentFilters.contains("Terminé") ? 1 : 0;
    switch (count) {
      case 0:
        return "Pas de filtre";
      case 1:
        return "1 filtre appliqué";
      case 2:
        return "2 filtre appliqué";
      case 3:
        return "Tout";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(getSubtitleIncident(),
        style: TextStyle(color: GlobalStyles.greyText, fontSize: 10));
  }
}
