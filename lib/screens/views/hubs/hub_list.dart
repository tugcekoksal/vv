// Vendor
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/carte_provider/carte_hub_provider.dart';
import 'package:velyvelo/helpers/logger.dart';

// Globals styles
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/screens/views/incidents_view/incidents_list_info.dart';
import 'package:velyvelo/screens/views/my_bikes/bikes_list.dart';

class PurpleText extends StatelessWidget {
  final String text;

  const PurpleText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Text(text,
            style: const TextStyle(
                color: global_styles.purple,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)));
  }
}

class HubCard extends ConsumerWidget {
  final int index;

  const HubCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
            bottom: 4.0, top: 4.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(children: [
          Text(
              ref.read(carteHubProvider).hubList[index].name ??
                  "Pas de nom de groupe",
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(
            ref.read(carteHubProvider).hubList[index].clientName ??
                "Pas de nom de client",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Icon(
                    Icons.location_pin,
                    color: global_styles.greyText,
                    size: 20,
                  )),
              Flexible(
                  child: Text(
                      ref.read(carteHubProvider).hubList[index].adress ??
                          "Pas d'adresse",
                      overflow: TextOverflow.ellipsis)),
              GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                            text: ref
                                    .read(carteHubProvider)
                                    .hubList[index]
                                    .adress ??
                                "Pas d'adresse"))
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                                    "Adresse copiée dans le presse-papier."))));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Icon(
                      Icons.copy,
                      color: global_styles.greyText,
                      size: 20,
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vous avez ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ref
                    .read(carteHubProvider)
                    .hubList[index]
                    .reparationsNb
                    .toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: global_styles.yellow),
              ),
              const Flexible(
                  child: Text(
                " réparations à effectuer.",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(
                Icons.people,
                color: global_styles.greyText,
                size: 20,
              ),
              Text(
                  ref.read(carteHubProvider).hubList[index].usersNb.toString()),
              Image.asset(
                "assets/pins/green_pin.png",
                width: 30,
              ),
              Text(
                ref.read(carteHubProvider).hubList[index].parkedNb.toString(),
                style: const TextStyle(color: global_styles.green),
              ),
              Image.asset(
                "assets/pins/blue_pin.png",
                width: 30,
              ),
              Text(
                ref.read(carteHubProvider).hubList[index].usedNb.toString(),
                style: const TextStyle(color: global_styles.blue),
              ),
              Image.asset(
                "assets/pins/orange_pin.png",
                width: 30,
              ),
              Text(
                ref.read(carteHubProvider).hubList[index].robbedNb.toString(),
                style: const TextStyle(color: global_styles.orange),
              ),
            ],
          ),
        ]));
  }
}

class HubsList extends ConsumerWidget {
  final refreshController = RefreshController();

  HubsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteHubProvider hubs = ref.watch(carteHubProvider);
    return Padding(
        padding: const EdgeInsets.only(top: 100, bottom: 60),
        child: FadeListView(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: refreshController,
            onRefresh: () {
              // Refresh incidents
              ref.read(carteHubProvider).fetchHubList();
              refreshController.refreshCompleted();
            },
            onLoading: () {
              // Add new incidents in the list with newest_id and count
              ref.read(carteHubProvider).fetchNewHubList().then((isNotEmpty) {
                if (isNotEmpty) {
                  refreshController.loadComplete();
                } else {
                  refreshController.loadNoData();
                }
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
              itemCount: hubs.hubList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: HubCard(
                    index: index,
                  ),
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

class HubsListView extends ConsumerWidget {
  final log = logger(HubsListView);
  HubsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // need change to hubLIstprovider
    final CarteHubProvider hubs = ref.watch(carteHubProvider);
    return Container(
        height: MediaQuery.of(context).size.height,
        color: global_styles.backgroundLightGrey,
        // If Hubs are loading
        child: hubs.isLoadingHub
            ? const Padding(
                padding: EdgeInsets.only(top: 100), child: ListIsLoading())
            // If there is an error loading hubs
            : hubs.messageError != ""
                ? InfoError(
                    icon: Icons.other_houses,
                    color: global_styles.orange,
                    text: "Une erreur s'est produite",
                    action: hubs.fetchHubList)
                // If load is successfull but there are no hubs
                : hubs.hubList.isEmpty
                    ? const InfoEmpty(
                        icon: Icons.other_houses,
                        color: global_styles.greyUnselectedIcon,
                        text: "Aucun hub trouvé")
                    // Else display the list of the Hubs
                    : HubsList());
  }
}
