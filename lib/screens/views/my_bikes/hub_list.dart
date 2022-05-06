// Vendor
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/hub_controller.dart';

// Globals styles
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
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
            style: TextStyle(
                color: GlobalStyles.purple,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)));
  }
}

class HubCard extends StatelessWidget {
  final HubModel hub;

  const HubCard({Key? key, required this.hub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(hub.adresse);
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
            bottom: 4.0, top: 4.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(children: [
          Text(hub.groupName ?? "Pas de nom de groupe",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(
            hub.clientName ?? "Pas de nom de client",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.location_pin,
                color: GlobalStyles.greyText,
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
                          SnackBar(
                              content: Text(
                                  "Adresse copiée dans le presse-papier."))))
                },
                icon: Icon(
                  Icons.copy,
                  color: GlobalStyles.greyText,
                  size: 20,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Vous avez ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                hub.reparations.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: GlobalStyles.yellow),
              ),
              Flexible(
                  child: Text(
                " réparations à effectuer.",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.people,
                color: GlobalStyles.greyText,
                size: 20,
              ),
              Text(hub.users.toString()),
              Image.asset(
                "assets/pins/green_pin.png",
                width: 30,
              ),
              Text(
                hub.bikeParked.toString(),
                style: TextStyle(color: GlobalStyles.green),
              ),
              Image.asset(
                "assets/pins/blue_pin.png",
                width: 30,
              ),
              Text(
                hub.bikeUsed.toString(),
                style: TextStyle(color: GlobalStyles.blue),
              ),
              Image.asset(
                "assets/pins/orange_pin.png",
                width: 30,
              ),
              Text(
                hub.bikeRobbed.toString(),
                style: TextStyle(color: GlobalStyles.orange),
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
    return Obx(() {
      return Container(
          color: GlobalStyles.backgroundLightGrey,
          child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: FadeListView(
                // Need to enable refresh here !
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
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
                    padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                    itemCount: hubController.hubs.length,
                    itemBuilder: (context, index) {
                      // hubController
                      //     .fetchOneHub(hubController.hubs[index].id ?? -1);
                      return (GestureDetector(
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
                      ));
                    },
                  ),
                ),
              )));
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
    init();
    return Obx(() {
      if (hubController.isLoadingHub.value) {
        return Padding(
            padding: EdgeInsets.only(top: 100), child: ListIsLoading());
      } else if (hubController.error.value != "") {
        return InfoError(
            icon: Icons.other_houses,
            color: GlobalStyles.orange,
            text: "Une erreur s'est produite",
            action: init);
      } else if (hubController.hubs.length == 0) {
        return InfoEmpty(
            icon: Icons.other_houses,
            color: GlobalStyles.greyUnselectedIcon,
            text: "Aucun hub trouvé");
      } else {
        return HubsList(hubController: hubController);
      }
    });
  }
}
