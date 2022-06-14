// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';

//Controllers
import 'package:velyvelo/controllers/login_controller.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      loginController.isLogged.value ? title : "VelyVelo",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: global_styles.backgroundDarkGrey,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700),
                    )
                  ]))
          : Text(
              loginController.isLogged.value ? title : "VelyVelo",
              style: const TextStyle(
                  color: global_styles.backgroundDarkGrey,
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
    count += incidentController.incidentFilters.contains("Planifié") ? 1 : 0;
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
        style: const TextStyle(color: global_styles.greyText, fontSize: 10));
  }
}
