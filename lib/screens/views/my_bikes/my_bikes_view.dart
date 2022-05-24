// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// Global Styles like colors
import 'package:velyvelo/controllers/hub_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/screens/home/button_account.dart';
import 'package:velyvelo/screens/home/button_scan.dart';
import 'package:velyvelo/screens/home/title_app_bar.dart';
import 'package:velyvelo/screens/views/my_bikes/button_filter.dart';
import 'package:velyvelo/screens/views/my_bikes/button_search.dart';
import 'package:velyvelo/screens/views/my_bikes/button_velo.dart';
import 'package:velyvelo/screens/views/my_bikes/hub_list.dart';
import 'package:velyvelo/screens/views/my_bikes/hub_map.dart';
import 'package:velyvelo/screens/views/my_bikes/info_usage.dart';

// Own modules
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';
import 'package:velyvelo/screens/views/my_bikes/bikes_map.dart';
import 'package:velyvelo/screens/views/my_bikes/bikes_list.dart';

// Access Token
const accesToken =
    "sk.eyJ1IjoibHVjYXNncmFmZW4iLCJhIjoiY2wwNnA2a3NnMDRndzNpbHYyNTV0NGd1ZCJ9.nfFc_JlfaGgq1Kajg6agoQ";

class MyBikesView extends StatefulWidget {
  MyBikesView({Key? key}) : super(key: key);

  @override
  State<MyBikesView> createState() => _MyBikesViewState();
}

class _MyBikesViewState extends State<MyBikesView> {
  final MapBikesController mapBikesController = Get.put(MapBikesController());
  final HubController hubController = Get.put(HubController());
  final LoginController loginController = Get.put(LoginController());
  final Logger log = logger(MyBikesView);

  void changeMapView() {
    setState(() {
      mapBikesController.changeMapView();
    });
  }

  void changeMapStyle() {
    setState(() {
      mapBikesController.changeMapStyle();
    });
  }

  void init() {
    if (loginController.isAdminOrTech()) {
      hubController.fetchHubs();
    }
    mapBikesController.fetchAllBikes();

    // mapBikeController.didNotFoundBikesWithPosition.value = true;
    // mapBikeController.isLoading.value = true;
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Stack(children: [
      // HUB OR BIKES ?
      Obx(() {
        log.d("RENDER");
        return hubController.hubView.value
            ? mapBikesController.isMapView
                ? HubMap(
                    hubController: hubController,
                    streetView: hubController.isStreetView,
                  )
                : HubsListView(hubController: hubController)
            :
            // MAP OR LIST
            mapBikesController.isMapView
                ? BikesMap(
                    mapBikeController: mapBikesController,
                    streetView: mapBikesController.isStreetView)
                : BikesListView(mapBikeController: mapBikesController);
      }),

      // APP BAR
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top buttons (whites)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        log.d("RENDER overlay");

                        return Row(
                          children: [
                            ButtonAccount(),
                            const SizedBox(width: 5),
                            hubController.hubView.value
                                ? ButtonSearchHub(
                                    hubController: hubController,
                                  )
                                : ButtonSearchVelo(
                                    mapBikesController: mapBikesController,
                                  ),
                          ],
                        );
                      }),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        GestureDetector(
                          onTap: () => {
                            hubController.hubView.value
                                ? hubController.fetchHubs()
                                : mapBikesController.fetchAllBikes()
                          },
                          child: Obx(() {
                            log.d("RENDER title");

                            return TitleAppBar(
                              onTransparentBackground:
                                  mapBikesController.isMapView,
                              title: hubController.hubView.value
                                  ? "Hubs"
                                  : "Vélos",
                            );
                          }),
                        )
                      ]),
                      Obx(() {
                        log.d("RENDER filter");

                        return Row(children: [
                          hubController.hubView.value
                              ? const SizedBox(width: 40)
                              : ButtonFilter(
                                  mapBikesController: mapBikesController),
                          const SizedBox(width: 5),
                          const ButtonScan()
                        ]);
                      })
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (loginController.isAdminOrTech.value)
                        Row(children: [
                          ButtonTypeMapElem(
                              hubController: hubController, isHub: false),
                          const SizedBox(width: 5),
                          ButtonTypeMapElem(
                              hubController: hubController, isHub: true),
                        ]),
                      if (!loginController.isAdminOrTech.value)
                        const SizedBox(),
                      TopSwitch(
                          changeMapView: changeMapView,
                          mapBikesController: mapBikesController)
                    ])
              ])),
      Positioned(
          bottom: 75,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  log.d("RENDER pop up");

                  return InfoLoading(
                      text: "Chargement des données",
                      isVisible: mapBikesController.isLoading.value ||
                          hubController.isLoadingHub.value);
                }),
              ],
            ),
          )),
      // Little pop informatives
      Positioned(
          bottom: 75,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  log.d("RENDER pop up not found");

                  return InfoNotFound(
                      color: global_styles.blue,
                      text: "Aucun résultat",
                      isVisible: mapBikesController
                              .didNotFoundBikesWithPosition.value &&
                          !hubController.hubView.value &&
                          mapBikesController.isMapView);
                })
              ],
            ),

            // Little pop informatives
          )),
      // Search bar
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            log.d("RENDER searchbars");

            return hubController.hubView.value
                ? hubController.displaySearch.value
                    ? SearchBarHub()
                    : const SizedBox()
                : mapBikesController.displaySearch.value
                    ? SearchBarVelo()
                    : const SizedBox();
          }),
          const SizedBox(),
        ],
      )
    ]);
  }
}

// class BuildErrorMessage extends StatelessWidget {
//   const BuildErrorMessage({
//     Key? key,
//     required this.mapBikeController,
//   }) : super(key: key);

//   final MapBikesController mapBikeController;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Padding(
//       padding: const EdgeInsets.all(50.0),
//       child: Text(
//         mapBikeController.error.value,
//         style: TextStyle(
//             color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
//         textAlign: TextAlign.center,
//       ),
//     ));
//   }
// }
