// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_long;
import 'package:velyvelo/controllers/carte_provider/carte_hub_provider.dart';
import 'package:velyvelo/controllers/map_provider/camera_provider.dart';

// Controllers
import 'package:velyvelo/screens/views/hubs/hub_popup.dart';
import 'package:velyvelo/screens/views/my_bikes/pin.dart';

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
    CameraProvider camera, CarteHubProvider hubs) {
  if (camera.firstTime) {
    camera.firstTime = false;
    return;
  }

  // When zoom is too large
  if (position.zoom != null) {
    if ((camera.oldZoom - position.zoom!).abs() > 1) {
      camera.updateZoom(position.zoom!);
      hubs.fetchHubMap();
    }
  }
  // When map axe x or y movement is too large
  if (position.bounds != null) {
    if (position.bounds!.contains(camera.oldPosition) == false) {
      camera.updatePosition(position.center!);
      hubs.fetchHubMap();
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
  HubMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteHubProvider hubs = ref.watch(carteHubProvider);
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
                      ref.read(cameraProvider), ref.read(carteHubProvider))
                });
          },
          center: lat_long.LatLng(47.8, 2.350492773209436),
          zoom: 5.1,
          minZoom: 3,
          maxZoom: 21.0,
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          // plugins: [
          //   MarkerClusterPlugin(),
          // ],
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            minZoom: 3,
            maxZoom: 21,
            keepBuffer: 5,
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 120,
              size: const Size(40, 40),
              fitBoundsOptions: const FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: hubs.hubMap.map((hub) {
                return Marker(
                    width: 35.0,
                    height: 80.0,
                    point:
                        lat_long.LatLng(hub.latitude ?? 0, hub.longitude ?? 0),
                    builder: (ctx) {
                      return HubPin(hub: hub);
                    });
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
                      border:
                          Border.all(color: global_styles.purple, width: 2.0),
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
                  popupState: PopupState(),
                  popupController: popupController,
                  popupBuilder: (_, marker) {
                    hubs.fetchPopupHub(marker);
                    if (hubs.hubPopup == null) {
                      return const SizedBox();
                    }
                    return ClipPath(
                      clipper: PopUpClipper(),
                      child: Container(
                        width: 300,
                        height: MediaQuery.of(context).size.height * 0.25,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Stack(
                          children: [
                            HubPopup(hubs: hubs),
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
          )
        ],
      ),
    ]);
  }
}
