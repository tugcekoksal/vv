// Vendor
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/hub_controller.dart';

// Globals styles
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/models/hubs/hub_map.dart';
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

class HubCard extends StatelessWidget {
  final HubModel hub;

  const HubCard({Key? key, required this.hub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
            bottom: 4.0, top: 4.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(children: [
          Text(hub.groupName ?? "Pas de nom de groupe",
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(
            hub.clientName ?? "Pas de nom de client",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(
                Icons.location_pin,
                color: global_styles.greyText,
                size: 20,
              ),
              Flexible(
                  child: Text(hub.adresse == "" ? "Pas d'adresse" : hub.adresse,
                      overflow: TextOverflow.ellipsis)),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => {
                  Clipboard.setData(ClipboardData(text: hub.adresse)).then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Adresse copiée dans le presse-papier."))))
                },
                icon: const Icon(
                  Icons.copy,
                  color: global_styles.greyText,
                  size: 20,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Text(
                "Vous avez ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                hub.reparations.toString(),
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
              Text(hub.users.toString()),
              Image.asset(
                "assets/pins/green_pin.png",
                width: 30,
              ),
              Text(
                hub.bikeParked.toString(),
                style: const TextStyle(color: global_styles.green),
              ),
              Image.asset(
                "assets/pins/blue_pin.png",
                width: 30,
              ),
              Text(
                hub.bikeUsed.toString(),
                style: const TextStyle(color: global_styles.blue),
              ),
              Image.asset(
                "assets/pins/orange_pin.png",
                width: 30,
              ),
              Text(
                hub.bikeRobbed.toString(),
                style: const TextStyle(color: global_styles.orange),
              ),
            ],
          ),
        ]));
  }
}

class HubsList extends StatelessWidget {
  final HubController hubController;

  const HubsList({Key? key, required this.hubController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("REBUILD LIST");
    return Obx(() {
      return Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 60),
          child: FadeListView(
            // Need to enable refresh here !
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              controller: hubController.refreshController,
              // controller: incidentController.refreshController,
              onRefresh: () {
                // Refresh incidents
                hubController.fetchHubs();
                hubController.refreshController.refreshCompleted();
              },
              onLoading: () {
                // Add new incidents in the list with newest_id and count
                // incidentController.fetchNewIncidents();
                hubController.refreshController.loadComplete();
              },
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                itemCount: hubController.hubs.length,
                itemBuilder: (context, index) {
                  // hubController
                  //     .fetchOneHub(hubController.hubs[index].id ?? -1);
                  return GestureDetector(
                    // child: Text("oeirgh"),
                    child: HubCard(
                      hub: hubController.hubs[index],
                    ),
                    onTap: () => {
                      // Go to nothing
                      // goToBikeProfileFromPk(
                      //     mapBikeController.bikeWithPositionList[index].veloPk,
                      //     mapBikeController)
                    },
                  );
                },
              ),
            ),
          ));
    });
  }
}

class HubsListView extends StatelessWidget {
  final HubController hubController;

  const HubsListView({Key? key, required this.hubController}) : super(key: key);

  void init() {
    hubController.fetchHubs();
    // hubController.hubs.refresh();
  }

  @override
  Widget build(BuildContext context) {
    // init();
    print("REBUILD VIEW");
    return Container(
        height: MediaQuery.of(context).size.height,
        color: global_styles.backgroundLightGrey,
        child: Obx(() {
          if (hubController.isLoadingHub.value) {
            return const Padding(
                padding: EdgeInsets.only(top: 100), child: ListIsLoading());
          } else if (hubController.error.value != "") {
            return InfoError(
                icon: Icons.other_houses,
                color: global_styles.orange,
                text: "Une erreur s'est produite",
                action: init);
          } else if (hubController.hubs.isEmpty) {
            return const InfoEmpty(
                icon: Icons.other_houses,
                color: global_styles.greyUnselectedIcon,
                text: "Aucun hub trouvé");
          } else {
            return HubsList(hubController: hubController);
          }
        }));
  }
}
