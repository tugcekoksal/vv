// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/carte_provider/carte_bike_provider.dart';
import 'package:velyvelo/controllers/carte_provider/carte_hub_provider.dart';

// Global Styles like colors
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/map_provider/map_view_provider.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/screens/home/button_account.dart';
import 'package:velyvelo/screens/home/button_scan.dart';
import 'package:velyvelo/screens/home/connexion_status.dart';
import 'package:velyvelo/screens/home/title_app_bar.dart';
import 'package:velyvelo/screens/views/my_bikes/button_filter.dart';
import 'package:velyvelo/screens/views/my_bikes/button_search.dart';
import 'package:velyvelo/screens/views/my_bikes/button_velo.dart';
import 'package:velyvelo/screens/views/hubs/hub_list.dart';
import 'package:velyvelo/screens/views/hubs/hub_map.dart';
import 'package:velyvelo/screens/views/my_bikes/info_usage.dart';

// Own modules
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';
import 'package:velyvelo/screens/views/my_bikes/bikes_map.dart';
import 'package:velyvelo/screens/views/my_bikes/bikes_list.dart';

// Access Token
const accesToken =
    "sk.eyJ1IjoibHVjYXNncmFmZW4iLCJhIjoiY2wwNnA2a3NnMDRndzNpbHYyNTV0NGd1ZCJ9.nfFc_JlfaGgq1Kajg6agoQ";

class MyBikesView extends ConsumerWidget {
  final log = logger(MyBikesView);
  MyBikesView({super.key});

  final LoginController loginController = Get.put(LoginController());

  // void init() {
  //   if (loginController.isAdminOrTech()) {
  //     // hubController.fetchHubs();
  //   }
  //   mapBikesController.fetchAllBikes();

  //   // mapBikeController.isLoading.value = true;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteHubProvider hubs = ref.watch(carteHubProvider);
    final CarteBikeProvider bikes = ref.watch(carteBikeProvider);
    final MapViewProvider view = ref.watch(mapViewProvider);

    // init();
    return Stack(children: [
      // HubView / BikesView
      view.isActiveMapView(WhichMapView.hubView)
          // Map view or List view
          ? view.isMapOrList(MapOrList.map)
              ? HubMap()
              : HubsListView()
          :
          // BIKESVIEW
          view.isMapOrList(MapOrList.map)
              // Map view or List view
              ? BikesMap()
              : const BikesListView(),

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
                      Row(
                        children: [
                          ButtonAccount(),
                          const SizedBox(width: 5),
                          // dynamic provider
                          view.isActiveMapView(WhichMapView.hubView)
                              ? const ButtonSearchHub()
                              : const ButtonSearchVelo(),
                        ],
                      ),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        GestureDetector(
                          onTap: () => {
                            view.isActiveMapView(WhichMapView.hubView)
                                ? hubs.fetch(view.isMapOrList(MapOrList.list))
                                : bikes.fetch(view.isMapOrList(MapOrList.list))
                          },
                          child: TitleAppBar(
                            onTransparentBackground:
                                view.isMapOrList(MapOrList.map),
                            title: view.isActiveMapView(WhichMapView.hubView)
                                ? "Hubs"
                                : "Vélos",
                          ),
                        )
                      ]),
                      Row(children: [
                        view.isActiveMapView(WhichMapView.bikeView)
                            ? const ButtonFilter()
                            : const SizedBox(width: 40),
                        const SizedBox(width: 5),
                        const ButtonScan()
                      ]),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (loginController.isAdminOrTech.value)
                        const Row(children: [
                          ButtonTypeMapElem(
                            whichView: WhichMapView.bikeView,
                          ),
                          SizedBox(width: 5),
                          ButtonTypeMapElem(
                            whichView: WhichMapView.hubView,
                          ),
                        ]),
                      if (!loginController.isAdminOrTech.value)
                        const SizedBox(),
                      const TopSwitch()
                    ])
              ])),
      Positioned(
          bottom: 75,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoLoading(
                    text: "Chargement des données",
                    isVisible: bikes.isLoadingBikes || hubs.isLoadingHub),
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
                InfoNotFound(
                    color: global_styles.blue,
                    text: "Aucun résultat",
                    isVisible: bikes.bikeMap.isEmpty &&
                        bikes.isLoadingBikes == false &&
                        view.isActiveMapView(WhichMapView.bikeView) &&
                        view.isMapOrList(MapOrList.map)),
              ],
            ),

            // Little pop informatives
          )),
      // Search bar
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          view.isActiveMapView(WhichMapView.hubView)
              ? hubs.displaySearch
                  ? SearchBarHub()
                  : const SizedBox()
              : bikes.filter.displaySearch
                  ? SearchBarVelo()
                  : const SizedBox(),
          const SizedBox(),
        ],
      ),
      const ConnexionStatus(),
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
