// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/screens/home/title_app_bar.dart';

class TitleIncidents extends ConsumerWidget {
  const TitleIncidents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider provider = ref.watch(incidentsProvider);
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: GestureDetector(
            // fetch on tap
            // onTap: () => incidentController
            //     .fetchAllIncidents(incidentController.incidentsToFetch.value),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          TitleAppBar(
            onTransparentBackground: false,
            title: provider.title,
          ),
        ])));
  }
}
