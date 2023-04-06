// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// Usefull
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/screens/home/connexion_status.dart';
import 'package:velyvelo/screens/views/incidents/components/list_incident.dart';
import 'package:velyvelo/screens/views/incidents/components/list_past_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/top/app_bar_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/list_client.dart';
import 'package:velyvelo/screens/views/incidents/components/list_group.dart';
import 'package:velyvelo/screens/views/incidents/components/switch_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/title_incidents.dart';
import 'package:velyvelo/screens/views/my_bikes/button_search.dart';

class IncidentsView extends ConsumerWidget {
  final IncidentController incidentController = Get.put(IncidentController());

  IncidentsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider wProvider = ref.watch(incidentsProvider);

    return Container(
        color: global_styles.backgroundLightGrey,
        child: Stack(alignment: Alignment.topCenter, children: [
          AppBarIncidents(),
          const TitleIncidents(),
          // const SwitchIncidents(),
          wProvider.view == View.listClient
              ? ListClient()
              : wProvider.view == View.listGroup
                  ? ListGroup()
                  : wProvider.view == View.listIncident
                      ? ListIncident()
                      : wProvider.view == View.historicIncident
                          ? ListPastIncident()
                          : const SizedBox(),
          // Search bar
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return incidentController.displaySearch.value
                    ? SearchBarIncident()
                    : const SizedBox();
              }),
              const ConnexionStatus(),
            ],
          ),
        ]));
  }
}
