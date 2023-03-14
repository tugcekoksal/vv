import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/models/incident/client_card_model.dart';
import 'package:velyvelo/screens/views/incidents/components/client_card.dart';
import 'package:velyvelo/screens/views/incidents/components/group_card.dart';
import 'package:velyvelo/screens/views/incidents/components/incident_card.dart';

class ListIncident extends ConsumerWidget {
  final refreshController = RefreshController();

  ListIncident({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider wProvider = ref.watch(incidentsProvider);

    return Padding(
        padding: const EdgeInsets.only(top: 155, bottom: 60),
        child: FadeListView(
          child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: refreshController,
              onRefresh: () {
                // Refresh incidents
                refreshController.refreshCompleted();
              },
              onLoading: () {
                // Add new incidents in the list with newest_id and count
                bool isNotEmpty = true;
                if (isNotEmpty) {
                  refreshController.loadComplete();
                } else {
                  refreshController.loadNoData();
                }
              },
              child: ListView(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 20.0),
                    child: Column(
                      children: [
                        GroupCard(group: wProvider.selectedGroup),
                        const SizedBox(height: 20),
                        // test
                        for (var index = 0;
                            index < wProvider.incidentCards.length;
                            index++)
                          GestureDetector(
                            child: IncidentCard(
                                incident: wProvider.incidentCards[index]),
                            onTap: () {
                              wProvider.selectGroup(index);
                            },
                          )
                      ],
                    )),
              ])),
        ));
  }
}
