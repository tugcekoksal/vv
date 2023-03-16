import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/components/incident_overview.dart';
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/models/incident/client_card_model.dart';
import 'package:velyvelo/screens/views/incident_detail/incident_detail_view.dart';
import 'package:velyvelo/screens/views/incidents/components/client_card.dart';
import 'package:velyvelo/screens/views/incidents/components/group_card.dart';
import 'package:velyvelo/screens/views/incidents/components/incident_card.dart';
import 'package:velyvelo/screens/views/old_incident_view/incidents_list.dart';
import 'package:velyvelo/screens/views/old_incident_view/incidents_list_info.dart';

class ListPastIncident extends StatelessWidget {
  final refreshController = RefreshController();
  final IncidentController incidentController = Get.put(IncidentController());

  ListPastIncident({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 150.0),
      Obx(() {
        if (incidentController.isLoading.value) {
          return const ListIncidentIsLoading();
        } else if (incidentController.error.value != '') {
          return IncidentListError(incidentController: incidentController);
        } else if (incidentController.isIncidentListEmpty.value) {
          return IncidentListEmpty(incidentController: incidentController);
        } else {
          return IncidentsList(incidentController: incidentController);
        }
      })
    ]);
  }
}
