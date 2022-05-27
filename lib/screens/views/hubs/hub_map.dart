// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/controllers/hub_controller.dart';

// Vendor
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_long;
import 'package:velyvelo/controllers/hub_provider/hub_provider.dart';
import 'package:velyvelo/controllers/map_provider/camera_provider.dart';

// Controllers
import 'package:velyvelo/models/hubs/hub_map.dart';
import 'package:velyvelo/screens/views/hubs/hub_popup.dart';
import 'package:velyvelo/screens/views/my_bikes/pin.dart';

// Parameters mapbox
const streetsIntegrationUrl =
    "https://api.mapbox.com/styles/v1/kfenoire/cl2eu6p1a000k15lt6ynzfbns/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2Zlbm9pcmUiLCJhIjoiY2wyZXQ3YjI1MDFqbjNpbGp5am0xNmNuNyJ9.ozXrVxONYXi2YWozuPdQFA";
const satteliteIntegrationUrl =
    "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2Zlbm9pcmUiLCJhIjoiY2wyZXQ3YjI1MDFqbjNpbGp5am0xNmNuNyJ9.ozXrVxONYXi2YWozuPdQFA";

const accesToken =
    "pk.eyJ1Ijoia2Zlbm9pcmUiLCJhIjoiY2wyZXQ3YjI1MDFqbjNpbGp5am0xNmNuNyJ9.ozXrVxONYXi2YWozuPdQFA";

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

void onGeoChangeActualize(
    MapPosition position, bool hasGesture, CameraProvider camera) {
  print("ON GEO CHANGE");
  // if (firstTime) {
  //   firstTime = false;
  //   return;
  // }
  // When zoom is too large
  if (position.zoom != null) {
    if ((camera.oldZoom - position.zoom!).abs() > 1) {
      camera.updateZoom(position.zoom!);
      // hub.fetchHubs();
    }
  }
  // When map axe x or y movement is too large
  if (position.bounds != null) {
    if (position.bounds!.contains(camera.oldPosition) == false) {
      camera.updatePosition(position.center!);
      // hub.fetchHubs();
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

class HubMap extends ConsumerWidget {
  final PopupController popupController = PopupController();

  HubMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HubProvider hub = ref.watch(hubProvider);
    final CameraProvider camera = ref.watch(cameraProvider);

    return Stack(children: [
      FlutterMap(
        options: MapOptions(
          onTap: (tap, pos) => {popupController.hideAllPopups()},
          onPositionChanged: (MapPosition position, bool hasGesture) {
            Future(() => {
                  onGeoChangeActualize(
                      position, hasGesture, ref.read(cameraProvider))
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
            markers:
                hub.hubs.where((hub) => hub.adresse != "").toList().map((hub) {
              return Marker(
                  width: 35.0,
                  height: 80.0,
                  point: lat_long.LatLng(hub.pinModel?.latitude ?? 0,
                      hub.pinModel?.longitude ?? 0),
                  builder: (ctx) => HubPin(hub: hub.pinModel ?? HubPinModel()));
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
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0)),
                alignment: Alignment.center,
                child: Text(markers.length.toString(),
                    style: const TextStyle(
                        color: Colors.black,
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
                        height: 175,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Stack(
                          children: [
                            HubPopup(hub: hub.getHubFromMarker(marker)),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    popupController.togglePopup(marker),
                                child: const SizedBox(
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
      ),
    ]);
  }
}
