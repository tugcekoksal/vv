// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_long;

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/carte_provider/carte_bike_provider.dart';
import 'package:velyvelo/controllers/carte_provider/carte_hub_provider.dart';

// Controllers
import 'package:velyvelo/controllers/map_provider/camera_provider.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/screens/views/my_bikes/pin.dart';
import 'package:velyvelo/screens/views/my_bikes/usefull.dart';

// Parameters mapbox
const streetsIntegrationUrl =
    "https://api.mapbox.com/styles/v1/alexis-merck/ckzo13nez002c15r07s9ps7ys/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxleGlzLW1lcmNrIiwiYSI6ImNrenF3MGlrcDBldGgyd211YmQ5dWx4bXMifQ.DQkl2yEVn4jMmr-_WwBkdQ";
const satteliteIntegrationUrl =
    "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxleGlzLW1lcmNrIiwiYSI6ImNrenF3MGlrcDBldGgyd211YmQ5dWx4bXMifQ.DQkl2yEVn4jMmr-_WwBkdQ";

const accesToken =
    "pk.eyJ1IjoiYWxleGlzLW1lcmNrIiwiYSI6ImNrenF3MGlrcDBldGgyd211YmQ5dWx4bXMifQ.DQkl2yEVn4jMmr-_WwBkdQ";

const idSattelite = "mapbox.satellite";
const idStreets = "mapbox.mapbox-streets-v8";

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

void onGeoChangeActualize(MapPosition position, bool hasGesture,
    CameraProvider camera, CarteBikeProvider bikeMap) {
  bool hasFetch = false;

  // Handle conflict render GETX / STATE render widget, the onGeoChanged function trigger one time at the start when the widget is not fully built
  if (camera.firstTime) {
    camera.firstTime = false;
    return;
  }

  // When zoom is too large
  if (position.zoom != null) {
    if ((camera.oldZoom - position.zoom!).abs() > 1 && hasFetch == false) {
      camera.oldZoom = position.zoom!;
      bikeMap.fetchBikeMap();
      hasFetch = true;
    }
  }
  // When map axe x or y movement is too large
  if (position.bounds != null) {
    if (position.bounds!.contains(camera.oldPosition) == false &&
        hasFetch == false) {
      camera.oldPosition = position.center!;
      bikeMap.fetchBikeMap();
      hasFetch = true;
    }
  }
  // When far zoom display map style
  if (position.zoom! <= 18) {
    camera.toggleStreetView(true);
  }
  // When close zoom display streetView style
  else if (position.zoom! >= 18) {
    camera.toggleStreetView(false);
  }
}

class BikesMap extends ConsumerWidget {
  final PopupController popupController = PopupController();
  final log = logger(BikesMap);

  BikesMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteBikeProvider bikes = ref.watch(carteBikeProvider);
    final CameraProvider camera = ref.watch(cameraProvider);

    return Stack(children: [
      FlutterMap(
        options: MapOptions(
          onTap: (tap, pos) => {
            ref.read(carteHubProvider).cleanPopup(),
            popupController.hideAllPopups()
          },
          onPositionChanged: (MapPosition position, bool hasGesture) {
            Future(() => {
                  onGeoChangeActualize(position, hasGesture,
                      ref.read(cameraProvider), ref.read(carteBikeProvider))
                });
          },
          center: lat_long.LatLng(47.8, 2.350492773209436),
          zoom: 5.1,
          minZoom: 3,
          maxZoom: 21.0,
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          plugins: [
            MarkerClusterPlugin(),
          ],
        ),
        layers: [
          TileLayerOptions(
              opacity: 1,
              urlTemplate: camera.streetView
                  ? streetsIntegrationUrl
                  : satteliteIntegrationUrl,
              minZoom: 3,
              maxZoom: 21,
              updateInterval: 100,
              keepBuffer: 5,
              tileFadeInDuration: 100,
              tileFadeInStart: 0.5,
              tileFadeInStartWhenOverride: 0.5,
              additionalOptions: {
                "accessToken": accesToken,
              }),
          MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            size: const Size(40, 40),
            fitBoundsOptions: const FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: bikes.bikeMap.map((bike) {
              return Marker(
                  width: 35.0,
                  height: 80.0,
                  point:
                      lat_long.LatLng(bike.latitude ?? 0, bike.longitude ?? 0),
                  builder: (ctx) => Pin(status: bike.mapStatus ?? ""));
            }).toList(),
            polygonOptions: const PolygonOptions(
                borderColor: Color.fromARGB(0, 255, 255, 255),
                color: Color.fromARGB(0, 255, 255, 255),
                borderStrokeWidth: 0),
            builder: (context, markers) {
              return Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: global_styles.purple, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0)),
                alignment: Alignment.center,
                child: Text(markers.length.toString(),
                    style: const TextStyle(
                        color: global_styles.purple,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0)),
              );
            },
            popupOptions: PopupOptions(
                popupController: popupController,
                popupBuilder: (_, marker) {
                  bikes.fetchPopupBike(marker);
                  if (bikes.bikePopup == null) {
                    return const SizedBox();
                  }
                  return ClipPath(
                    clipper: PopUpClipper(),
                    child: Container(
                      width: 300,
                      height: 170,
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Text(
                                bikes.bikePopup?.name ?? "Pas de nom de vélo",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: global_styles.greyAddPhotos),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Dernière émission le \n',
                                  style: const TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: bikes.bikePopup?.timestamp ??
                                            "Pas d'émission",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              GestureDetector(
                                  // to change with actual popup bike id
                                  onTap: () => goToBikeProfileFromMarker(
                                      marker, ref.read(carteBikeProvider)),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: global_styles.blue),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 7.5),
                                    child: Text(
                                      "Voir le profil".toUpperCase(),
                                      style: const TextStyle(
                                          color: global_styles.blue,
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
                              onTap: () {
                                ref.read(carteHubProvider).cleanPopup();
                                popupController.togglePopup(marker);
                              },
                              child: const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Icon(Icons.close)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    ]);
  }
}
