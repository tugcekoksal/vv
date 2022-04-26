// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/BuildLoadingBox.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

class BuildIncidentsOverview extends StatelessWidget {
  BuildIncidentsOverview({Key? key, required this.setFilterTab})
      : super(key: key);

  final Function setFilterTab;
  final IncidentController incidentController = Get.put(IncidentController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.only(top: 15.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
                onTap: () => setFilterTab("Nouvelle"),
                child: Obx(() {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: incidentController.incidentFilters
                                  .contains("Nouvelle")
                              ? GlobalStyles.greyLine
                              : Colors.white,
                          width: 3.0,
                        ),
                      )),
                      child: BuildStatus(
                          numberOfTile:
                              incidentController.nbOfNewIncidents.value,
                          title: "Nouvelle",
                          backgroundColor: GlobalStyles.blue));
                })),
            SizedBox(width: 25.0),
            GestureDetector(
                onTap: () => setFilterTab("En cours"),
                child: Obx(() {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: incidentController.incidentFilters
                                  .contains("En cours")
                              ? GlobalStyles.greyLine
                              : Colors.white,
                          width: 3.0,
                        ),
                      )),
                      child: BuildStatus(
                          numberOfTile:
                              incidentController.nbOfProgressIncidents.value,
                          title: "En cours",
                          backgroundColor: GlobalStyles.yellow));
                })),
            SizedBox(width: 25.0),
            GestureDetector(
                onTap: () => setFilterTab("Terminé"),
                child: Obx(() {
                  return Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: incidentController.incidentFilters
                                  .contains("Terminé")
                              ? GlobalStyles.greyLine
                              : Colors.white,
                          width: 3.0,
                        ),
                      )),
                      child: BuildStatus(
                          numberOfTile:
                              incidentController.nbOfFinishedIncidents.value,
                          title: "Terminé",
                          backgroundColor: GlobalStyles.green));
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
                      color: GlobalStyles.purple,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800)));
        }),
        SizedBox(height: 5.0),
        Obx(() {
          if (incidentController.isLoading.value) {
            return BuildLoadingBox(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text('Nouvelle'),
            ));
          } else {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800)));
          }
        })
      ]),
    );
  }
}
