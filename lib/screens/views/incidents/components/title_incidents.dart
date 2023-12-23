// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/screens/home/title_app_bar.dart';

class TitleIncidents extends ConsumerWidget {
  const TitleIncidents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider provider = ref.watch(incidentsProvider);
    return GestureDetector(
        // fetch on tap
        // onTap: () => incidentController
        //     .fetchAllIncidents(incidentController.incidentsToFetch.value),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            height: 100,
            padding: const EdgeInsets.fromLTRB(115, 40, 115, 0),
            child: Center(
                child: TitleAppBar(
              onTransparentBackground: false,
              title: provider.title,
            )),
          )
        ]));
  }
}
