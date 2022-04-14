// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

// Components
import 'package:velyvelo/components/BuildPopUpFilters.dart';

// Helpers
import 'package:velyvelo/config/colorMarkers.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/config/markersPaths.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

// Access Token
const accesToken =
    "sk.eyJ1IjoibHVjYXNncmFmZW4iLCJhIjoiY2wwNnA2a3NnMDRndzNpbHYyNTV0NGd1ZCJ9.nfFc_JlfaGgq1Kajg6agoQ";

class MyBikesView extends StatelessWidget {
  MyBikesView({Key? key}) : super(key: key);

  final MapBikesController mapBikeController = Get.put(MapBikesController());

  final PopupController popupController = new PopupController();

  // Method to instantiate the filter's page
  Future<void> showFilters(context) async {
    mapBikeController.isFiltersChanged(false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BuildPopUpFilters();
        }).then((value) {
      // Check if filters have changed and fire the fetch of bikes if true
      mapBikeController.onChangeFilters();
      // If fetchAllBikes() gets no bikes then show it to the user
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      Obx(() {
        return FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(48.85942707304794, 2.350492773209436),
            zoom: 11.0,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            plugins: [
              MarkerClusterPlugin(),
            ],
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/aurelienhmdy/ckysvoerp6zwt14o4waw19zue/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXVyZWxpZW5obWR5IiwiYSI6ImNreXN1emx2NzA4ZHkzMXBscThid2s5amsifQ.67nOlu5x2vJbN1q0HKLyeA",
                additionalOptions: {
                  "accessToken": accesToken,
                  "id": "mapbox.mapbox-streets-v8"
                }),
            MarkerClusterLayerOptions(
              maxClusterRadius: 120,
              size: Size(40, 40),
              fitBoundsOptions: FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: mapBikeController.bikeWithPositionList.map((bike) {
                return Marker(
                    width: 50.0,
                    height: 50.0,
                    point: latLng.LatLng(bike.pos.latitude, bike.pos.longitude),
                    builder: (ctx) => Container(
                        child: Image.asset(MarkersPaths[
                            mapBikeController.selectedStatus.value])));
              }).toList(),
              polygonOptions: PolygonOptions(
                  borderColor: getColorBasedOnMarkersStatus(
                      mapBikeController.selectedStatus.value),
                  color: Colors.white12,
                  borderStrokeWidth: 1),
              builder: (context, markers) {
                return Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: getColorBasedOnMarkersStatus(
                              mapBikeController.selectedStatus.value),
                          width: 2.0),
                      borderRadius: BorderRadius.circular(20.0)),
                  alignment: Alignment.center,
                  child: Text(markers.length.toString(),
                      style: TextStyle(
                          color: getColorBasedOnMarkersStatus(
                              mapBikeController.selectedStatus.value),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0)),
                );
              },
              popupOptions: PopupOptions(
                  popupController: popupController,
                  popupBuilder: (_, marker) => ClipPath(
                        clipper: PopUpClipper(),
                        child: Container(
                          width: 300,
                          height: 170,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    mapBikeController
                                        .buildPopUpContentName(marker),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: GlobalStyles.greyAddPhotos),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: 'Dernière émission le \n',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: mapBikeController
                                                .buildPopUpContentLastEmission(
                                                    marker),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  GestureDetector(
                                      onTap: () => mapBikeController
                                          .setBikeToNewRobbedStatus(marker),
                                      child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: GlobalStyles.orange),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 7.5),
                                        child: Text(
                                          "Signaler comme volé".toUpperCase(),
                                          style: TextStyle(
                                              color: GlobalStyles.orange,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                ],
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () =>
                                      popupController.togglePopup(marker),
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      child: Icon(Icons.close)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
            ),
          ],
        );
      }),
      Positioned(
          right: 10.0,
          top: 10.0,
          child: Obx(() {
            return GestureDetector(
                onTap: () {
                  if (!mapBikeController.isLoadingFilters.value)
                    showFilters(context);
                },
                child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: mapBikeController.isLoadingFilters.value
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: GlobalStyles.greyTitle,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.filter_list_outlined,
                            color: GlobalStyles.greyTitle,
                            size: 30.0,
                          )));
          })),
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
          }))
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

class PopUpClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double width = size.width;
    final double height = size.height;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, width, height * 0.85), const Radius.circular(12)))
      ..moveTo(size.width * 0.5 - 20, size.height * 0.85)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.5 + 20, size.height * 0.85)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
