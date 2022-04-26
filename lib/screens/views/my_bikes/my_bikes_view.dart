// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

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
  final MapBikesController mapBikeController = Get.put(MapBikesController());

  void changeMapView() {
    setState(() {
      mapBikeController.changeMapView();
    });
  }

  void changeMapStyle() {
    setState(() {
      mapBikeController.changeMapStyle();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      mapBikeController.isMapView
          ? BikesMap(
              mapBikeController: mapBikeController,
              streetView: mapBikeController.isStreetView)
          : BikesList(mapBikeController: mapBikeController),
      Padding(
          padding: EdgeInsets.only(top: 80),
          child: TopOptions(
            mapBikesController: mapBikeController,
            changeMapView: changeMapView,
            changeMapStyle: changeMapStyle,
          )),
      Positioned(
          bottom: 0,
          child: Obx(() {
            return AnimatedOpacity(
              opacity: mapBikeController.isLoading.value ? 1 : 0,
              duration: Duration(milliseconds: 750),
              child: Container(
                width: screenWidth * 0.9,
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                    color: GlobalStyles.backgroundDarkGrey,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Chargement des vélos",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
      Positioned(
          bottom: 0,
          child: Obx(() {
            return AnimatedOpacity(
              opacity:
                  mapBikeController.didNotFoundBikesWithPosition.value ? 1 : 0,
              duration: Duration(milliseconds: 750),
              child: Container(
                width: screenWidth * 0.9,
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                    color: GlobalStyles.yellow,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Aucun vélo n'a été trouvé.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500)),
                    Icon(Icons.info_outline, color: Colors.white, size: 25.0)
                  ],
                ),
              ),
            );
          })),
    ]);
  }
}

class BuildErrorMessage extends StatelessWidget {
  const BuildErrorMessage({
    Key? key,
    required this.mapBikeController,
  }) : super(key: key);

  final MapBikesController mapBikeController;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(50.0),
      child: Text(
        mapBikeController.error.value,
        style: TextStyle(
            color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    ));
  }
}
