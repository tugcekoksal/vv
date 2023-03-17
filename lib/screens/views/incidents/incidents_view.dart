// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// Usefull
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/screens/views/incidents/components/list_incident.dart';
import 'package:velyvelo/screens/views/incidents/components/list_past_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/top/app_bar_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/list_client.dart';
import 'package:velyvelo/screens/views/incidents/components/list_group.dart';
import 'package:velyvelo/screens/views/incidents/components/switch_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/title_incidents.dart';
import 'package:velyvelo/screens/views/my_bikes/button_search.dart';

class ConnexionInfoContainer extends StatelessWidget {
  final Color color;
  final String text;
  final LoginController loginController;

  const ConnexionInfoContainer(
      {Key? key,
      required this.color,
      required this.text,
      required this.loginController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: double.infinity,
      height: 100,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const SizedBox(height: 1),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        GestureDetector(
            onTap: () {
              loginController.isDismiss.value = true;
            },
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white)),
                child: const Text(
                  "Compris !",
                  style: TextStyle(color: Colors.white),
                ))),
        const SizedBox(height: 1),
      ]),
    );
  }
}

class ConnexionInfo extends ConsumerWidget {
  final LoginController loginController = Get.put(LoginController());

  ConnexionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Obx(() {
      return loginController.hasConnexion.value == true &&
              loginController.isDismiss.value == false
          ? ConnexionInfoContainer(
              loginController: loginController,
              color: Colors.green,
              text: "Vous êtes connecté à internet")
          : loginController.hasConnexion.value == false &&
                  loginController.isDismiss.value == false
              ? ConnexionInfoContainer(
                  loginController: loginController,
                  color: Colors.red,
                  text: "Vous n'êtes plus connecté à internet")
              : const SizedBox();
    });
  }
}

class IncidentsView extends ConsumerWidget {
  final IncidentController incidentController = Get.put(IncidentController());

  IncidentsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider wProvider = ref.watch(incidentsProvider);

    return Stack(children: [
      Container(
          color: global_styles.backgroundLightGrey,
          child: Stack(alignment: Alignment.topCenter, children: [
            AppBarIncidents(),
            const TitleIncidents(),
            const SwitchIncidents(),
            Container(
                child: wProvider.view == View.listClient
                    ? ListClient()
                    : wProvider.view == View.listGroup
                        ? ListGroup()
                        : wProvider.view == View.listIncident
                            ? ListIncident()
                            : wProvider.view == View.historicIncident
                                ? ListPastIncident()
                                : const SizedBox()),
            // Search bar
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  return incidentController.displaySearch.value
                      ? SearchBarIncident()
                      : const SizedBox();
                }),
                const SizedBox(),
                ConnexionInfo(),
              ],
            ),
          ]))
    ]);
  }
}
