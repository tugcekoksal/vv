import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/components/list_empty.dart';
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/models/incident/incident_card_model.dart';
import 'package:velyvelo/screens/views/incident_detail/incident_detail_view.dart';
import 'package:velyvelo/screens/views/incidents/components/group_card.dart';
import 'package:velyvelo/screens/views/incidents/components/incident_card.dart';

class ListIncident extends ConsumerWidget {
  final refreshController = RefreshController();
  final IncidentController incidentController = Get.put(IncidentController());

  ListIncident({Key? key}) : super(key: key);

  showIncidentDetailPage(IncidentCardModel incident) async {
    incidentController.currentIncidentId.value = int.parse(incident.incidentPk);
    await incidentController.fetchIncidentById(int.parse(incident.incidentPk));

    Get.to(() => IncidentDetail(incident: incident),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 400));
  }

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
                wProvider.fetchListReparation().then((value) {
                  if (wProvider.error != "") {
                    refreshController.refreshFailed();
                  } else {
                    refreshController.refreshCompleted();
                  }
                });
              },
              onLoading: () {
                // Add new incidents in the list with newest_id and count
                // bool isNotEmpty = true;
                // if (isNotEmpty) {
                //   refreshController.loadComplete();
                // } else {
                //   refreshController.loadNoData();
                // }
              },
              child: wProvider.incidentCards.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 20.0),
                      child: Column(
                        children: [
                          GroupCard(group: wProvider.selectedGroup),
                          const SizedBox(height: 20),
                          const ListEmpty(text: "Aucuns incidents")
                        ],
                      ))
                  : ListView(children: [
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
                                    showIncidentDetailPage(
                                        wProvider.incidentCards[index]);
                                  },
                                )
                            ],
                          )),
                    ])),
        ));
  }
}
