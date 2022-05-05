// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

// Globals styles
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
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

class MapStatusVelo extends StatelessWidget {
  final String text;
  const MapStatusVelo({Key? key, required this.text}) : super(key: key);

  Color colorBasedOnVeloMapStatus(String status) {
    switch (status) {
      case "Rangé":
        return GlobalStyles.green;
      case "Utilisé":
        return GlobalStyles.blue;
      case "Volé":
        return GlobalStyles.orange;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 100),
      child: Container(
          width: 90,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: colorBasedOnVeloMapStatus(text),
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Center(
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800)))),
    );
  }
}

class VeloCard extends StatelessWidget {
  final String name;
  final String group;
  final String mapStatus;

  const VeloCard({
    Key? key,
    required this.name,
    required this.group,
    required this.mapStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
            bottom: 4.0, top: 4.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PurpleText(text: name),
                MapStatusVelo(text: mapStatus),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [PurpleText(text: group)],
            )
          ],
        ));
  }
}

class BikesList extends StatelessWidget {
  final MapBikesController mapBikeController;

  const BikesList({Key? key, required this.mapBikeController})
      : super(key: key);

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
                        itemCount:
                            mapBikeController.bikeWithPositionList.length,
                        itemBuilder: (context, index) {
                          print(mapBikeController
                              .bikeWithPositionList[index].pos?.latitude);
                          return (GestureDetector(
                            child: VeloCard(
                                name: mapBikeController
                                    .bikeWithPositionList[index].name,
                                group: mapBikeController
                                    .bikeWithPositionList[index].group,
                                mapStatus: mapBikeController
                                    .bikeWithPositionList[index].mapStatus),
                            onTap: () => {
                              goToBikeProfileFromPk(
                                  mapBikeController
                                      .bikeWithPositionList[index].veloPk,
                                  mapBikeController)
                            },
                          ));
                        },
                      )))));
    });
  }
}
