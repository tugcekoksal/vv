// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Components
import 'package:velyvelo/components/BuildIncidentOverview.dart';
import 'package:velyvelo/screens/home/button_account.dart';
import 'package:velyvelo/screens/home/button_scan.dart';
import 'package:velyvelo/screens/home/title_app_bar.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/screens/views/incidents_view/incidents_list.dart';
import 'package:velyvelo/screens/views/incidents_view/incidents_list_info.dart';

class IncidentsView extends StatelessWidget {
  IncidentsView({Key? key}) : super(key: key);

  final IncidentController incidentController = Get.put(IncidentController());

  @override
  Widget build(BuildContext context) {
    return Container(
        color: GlobalStyles.backgroundLightGrey,
        // APP BAR
        child: Stack(alignment: Alignment.topCenter, children: [
          Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonAccount(),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      TitleAppBar(
                        onTransparentBackground: false,
                        title: "Mes incidents",
                      ),
                      SubTitleIncidents(incidentController: incidentController)
                    ]),
                    ButtonScan()
                  ])),
          // BODY
          Column(children: [
            SizedBox(height: 100.0),
            BuildIncidentsOverview(
              setFilterTab: incidentController.setStatusToDisplay,
            ),
            Obx(() {
              if (incidentController.isLoading.value) {
                return ListIncidentIsLoading();
              } else if (incidentController.error.value != '') {
                return IncidentListError(
                    incidentController: incidentController);
              } else if (incidentController.noIncidentsToShow.value) {
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
