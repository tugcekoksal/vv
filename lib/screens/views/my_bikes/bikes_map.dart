// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

// Helpers
import 'package:velyvelo/config/colorMarkers.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/config/markersPaths.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/models/map/map_model.dart';
import 'package:velyvelo/screens/views/my_bike_view.dart';
import 'package:velyvelo/screens/views/my_bikes/usefull.dart';

// Access Token
const accesToken =
    "sk.eyJ1IjoibHVjYXNncmFmZW4iLCJhIjoiY2wwNnA2a3NnMDRndzNpbHYyNTV0NGd1ZCJ9.nfFc_JlfaGgq1Kajg6agoQ";

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

class BikesMap extends StatelessWidget {
  final PopupController popupController = new PopupController();
  final MapBikesController mapBikeController;

  BikesMap({Key? key, required this.mapBikeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
              print(bike.mapStatus);
              return Marker(
                  width: 50.0,
                  height: 50.0,
                  point: latLng.LatLng(bike.pos.latitude, bike.pos.longitude),
                  builder: (ctx) => Container(
                      child: Image.asset(MarkersPaths[bike.mapStatus])));
            }).toList(),
            polygonOptions: PolygonOptions(
                borderColor: GlobalStyles.purple,
                color: Colors.white12,
                borderStrokeWidth: 1),
            builder: (context, markers) {
              return Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: GlobalStyles.purple, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0)),
                alignment: Alignment.center,
                child: Text(markers.length.toString(),
                    style: TextStyle(
                        color: GlobalStyles.purple,
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
                                    onTap: () => goToBikeProfileFromMarker(
                                        marker, mapBikeController),
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: GlobalStyles.blue),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 7.5),
                                      child: Text(
                                        "Voir le profil".toUpperCase(),
                                        style: TextStyle(
                                            color: GlobalStyles.blue,
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
    });
  }
}
