// Vendor
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/hub_controller.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

// Globals styles
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/models/hubs/hub_map.dart';
import 'package:velyvelo/screens/views/my_bikes/usefull.dart';

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
                              content: Text("Address copied to clipboard"))))
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

  void init() {
    hubController.fetchHubs();
    hubController.hubs.refresh();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100)).then((value) => {
          init(),
        });
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
                  controller: RefreshController(),
                  // controller: incidentController.refreshController,
                  onRefresh: () {
                    // Refresh incidents
                    print("OULALA");
                    // incidentController.refreshIncidentsList();
                    // incidentController.refreshController.refreshCompleted();
                  },
                  onLoading: () {
                    // Add new incidents in the list with newest_id and count
                    // incidentController.fetchNewIncidents();
                    // incidentController.refreshController.loadComplete();
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
