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
        padding: const EdgeInsets.only(top: 140, bottom: 60),
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
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
              itemCount: wProvider.clientCards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ClientCard(
                      client: wProvider.clientCards[index],
                      isTech: wProvider.loginController.isTech()),
                  onTap: () => {
                    // Go to Hub profile ?
                  },
                );
              },
            ),
          ),
        ));
  }
}
