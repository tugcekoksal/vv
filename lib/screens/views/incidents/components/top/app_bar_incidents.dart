// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';

// Usefull
import 'package:velyvelo/helpers/logger.dart';

// Components
import 'package:velyvelo/screens/home/button_account.dart';
import 'package:velyvelo/screens/home/button_scan.dart';
import 'package:velyvelo/screens/views/incidents/incidents_view.dart';

class AppBarIncidents extends StatelessWidget {
  final IncidentController incidentController = Get.put(IncidentController());
  final LoginController loginController = Get.put(LoginController());

  final log = logger(IncidentsView);

  AppBarIncidents({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            ButtonAccount(),
            const SizedBox(width: 5),
            // ButtonSearchIncident(incidentController: incidentController),
          ]),
          Row(children: [
            // !loginController.isUser.value ? ButtonFilter() : const SizedBox(),
            !loginController.isUser.value
                ? const SizedBox(width: 5)
                : const SizedBox(),
            const ButtonScan(),
          ]),
        ]));
  }
}
