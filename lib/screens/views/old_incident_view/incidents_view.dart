// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Components
import 'package:velyvelo/components/incident_overview.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/screens/home/button_account.dart';
import 'package:velyvelo/screens/home/button_scan.dart';
import 'package:velyvelo/screens/home/title_app_bar.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

import 'package:velyvelo/screens/views/my_bikes/button_search.dart';

// My components
import 'package:velyvelo/screens/views/incidents/components/button_filter.dart';
import 'package:velyvelo/screens/views/old_incident_view/incidents_list.dart';
import 'package:velyvelo/screens/views/old_incident_view/incidents_list_info.dart';

class IncidentsView extends StatelessWidget {
  IncidentsView({Key? key}) : super(key: key);

  final IncidentController incidentController = Get.put(IncidentController());
  final LoginController loginController = Get.put(LoginController());

  final log = logger(IncidentsView);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: global_styles.backgroundLightGrey,
        // APP BAR
        child: Stack(alignment: Alignment.topCenter, children: [
          // Padding(
          //     padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          //     child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Row(children: [
          //             ButtonAccount(),
          //             const SizedBox(width: 5),
          //             ButtonSearchIncident(
          //                 incidentController: incidentController),
          //           ]),
          //           Row(children: [
          //             !loginController.isUser.value
          //                 ? ButtonFilter()
          //                 : const SizedBox(),
          //             !loginController.isUser.value
          //                 ? const SizedBox(width: 5)
          //                 : const SizedBox(),
          //             const ButtonScan(),
          //           ]),
          //         ])),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: GestureDetector(
                  onTap: () => incidentController.fetchAllIncidents(
                      incidentController.incidentsToFetch.value),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TitleAppBar(
                      onTransparentBackground: false,
                      title: "Incidents",
                    ),
                    // SubTitleIncidents(incidentController: incidentController)
                  ]))),
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
            ],
          ),
          // BODY
          Column(children: [
            const SizedBox(height: 100.0),
            IncidentsOverview(
              setFilterTab: incidentController.setStatusToDisplay,
            ),
            Obx(() {
              if (incidentController.isLoading.value) {
                return const ListIncidentIsLoading();
              } else if (incidentController.error.value != '') {
                return IncidentListError(
                    incidentController: incidentController);
              } else if (incidentController.isIncidentListEmpty.value) {
                return IncidentListEmpty(
                    incidentController: incidentController);
              } else {
                return IncidentsList(incidentController: incidentController);
              }
            })
          ])
        ]));
  }
}
