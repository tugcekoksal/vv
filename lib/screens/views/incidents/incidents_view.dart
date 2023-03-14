// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Usefull
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/screens/views/incidents/components/list_incident.dart';
import 'package:velyvelo/screens/views/incidents/components/top/app_bar_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/list_client.dart';
import 'package:velyvelo/screens/views/incidents/components/list_group.dart';
import 'package:velyvelo/screens/views/incidents/components/switch_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/title_incidents.dart';

class IncidentsView extends ConsumerWidget {
  const IncidentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider wProvider = ref.watch(incidentsProvider);

    return Container(
        color: global_styles.backgroundLightGrey,
        child: Stack(alignment: Alignment.topCenter, children: [
          AppBarIncidents(),
          const TitleIncidents(),
          const SwitchIncidents(),
          wProvider.view == View.listClient
              ? ListClient()
              : wProvider.view == View.listGroup
                  ? ListGroup()
                  : wProvider.view == View.listIncident
                      ? ListIncident()
                      : const SizedBox()
        ]));
  }
}
