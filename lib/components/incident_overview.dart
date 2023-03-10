// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/loading_box.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';

class IncidentsOverview extends StatelessWidget {
  IncidentsOverview({Key? key, required this.setFilterTab}) : super(key: key);

  final Function setFilterTab;
  final IncidentController incidentController = Get.put(IncidentController());
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
                onTap: () => setFilterTab("Nouvelle"),
                child: Obx(() {
                  return Opacity(
                      opacity: incidentController.incidentFilters
                              .contains("Nouvelle")
                          ? 1
                          : 0.5,
                      child: BuildStatus(
                          numberOfTile:
                              incidentController.nbIncidents.value.nouvelle,
                          title: "Nouveau",
                          backgroundColor: global_styles.blue));
                })),
            const SizedBox(width: 25.0),
            loginController.isTech.value
                ? const SizedBox()
                : GestureDetector(
                    onTap: () => setFilterTab("Planifié"),
                    child: Obx(() {
                      return Opacity(
                          opacity: incidentController.incidentFilters
                                  .contains("Planifié")
                              ? 1
                              : 0.5,
                          child: BuildStatus(
                              numberOfTile:
                                  incidentController.nbIncidents.value.enCours,
                              title: "Planifié",
                              backgroundColor: global_styles.yellow));
                    })),
            const SizedBox(width: 25.0),
            GestureDetector(
                onTap: () => setFilterTab("Terminé"),
                child: Obx(() {
                  return Opacity(
                      opacity:
                          incidentController.incidentFilters.contains("Terminé")
                              ? 1
                              : 0.5,
                      child: BuildStatus(
                          numberOfTile:
                              incidentController.nbIncidents.value.termine,
                          title: "Terminé",
                          backgroundColor: global_styles.green));
                })),
          ])),
    );
  }
}

class BuildStatus extends StatelessWidget {
  final int? numberOfTile;
  final String title;
  final Color backgroundColor;

  BuildStatus({
    Key? key,
    required this.numberOfTile,
    required this.title,
    required this.backgroundColor,
  }) : super(key: key);

  final IncidentController incidentController = Get.put(IncidentController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(children: [
        Obx(() {
          return Opacity(
              opacity: incidentController.isLoading.value ? 0 : 1,
              child: Text(numberOfTile == null ? "0" : numberOfTile.toString(),
                  style: TextStyle(
                      color: backgroundColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800)));
        }),
        const SizedBox(height: 5.0),
        Obx(() {
          if (incidentController.isLoading.value) {
            return LoadingBox(
                child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text('Nouvelle'),
            ));
          } else {
            return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800)));
          }
        })
      ]),
    );
  }
}
