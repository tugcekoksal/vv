import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/models/incident/client_card_model.dart';
import 'package:velyvelo/screens/views/incidents/components/client_card.dart';
import 'package:velyvelo/screens/views/incidents/components/group_card.dart';

class ListGroup extends ConsumerWidget {
  final refreshController = RefreshController();

  ListGroup({Key? key}) : super(key: key);

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
                wProvider.fetchListGroup().then((value) {
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
              child: ListView(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 20.0),
                    child: Column(
                      children: [
                        ClientCard(
                            client: wProvider.selectedClient,
                            isTech: wProvider.loginController.isTech()),
                        for (var index = 0;
                            index < wProvider.groupCards.length;
                            index++)
                          GestureDetector(
                            child: GroupCard(
                              group: wProvider.groupCards[index],
                            ),
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
