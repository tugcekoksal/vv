import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/screens/views/incidents/components/client_card.dart';

class ListClient extends ConsumerWidget {
  final refreshController = RefreshController();

  ListClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider wProvider = ref.watch(incidentsProvider);

    return Padding(
        padding: const EdgeInsets.only(top: 100, bottom: 60),
        child: FadeListView(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: refreshController,
            onRefresh: () {
              // Refresh incidents
              wProvider.fetchListClient().then((value) {
                if (wProvider.error != "") {
                  refreshController.refreshFailed();
                } else {
                  refreshController.refreshCompleted();
                }
              }).catchError((e) {});
            },
            onLoading: () {
              // Add new incidents in the list with newest_id and count
              // if (wProvider.error == "") {
              //   refreshController.loadComplete();
              // } else {
              //   refreshController.loadFailed();
              // }
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 20.0),
              itemCount: wProvider.clientCards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ClientCard(
                      client: wProvider.clientCards[index],
                      isTech: wProvider.loginController.isTech()),
                  onTap: () {
                    ref.read(incidentsProvider).selectClient(index);
                  },
                );
              },
            ),
          ),
        ));
  }
}
