// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/hub_controller.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/config/markersPaths.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/screens/views/my_bikes/hub_popup.dart';
import 'package:velyvelo/screens/views/my_bikes/pin.dart';
import 'package:velyvelo/screens/views/my_bikes/usefull.dart';

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

// ignore: must_be_immutable
class HubMap extends StatefulWidget {
  final PopupController popupController = new PopupController();
  final HubController hubController;

  bool streetView;
  double oldZoom = 0;
  latLng.LatLng oldPosition = latLng.LatLng(0, 0);

  HubMap({Key? key, required this.hubController, required this.streetView})
      : super(key: key);

  @override
  State<HubMap> createState() => _HubMapState();
}

class _HubMapState extends State<HubMap> {
  void onGeoChanged(MapPosition position, bool hasGesture) {
    if (position.zoom != null) {
      if ((widget.oldZoom - position.zoom!).abs() > 1) {
        widget.oldZoom = position.zoom!;
        widget.hubController.fetchHubs();
      }
    }
    if (position.bounds != null) {
      if (position.bounds!.contains(widget.oldPosition) == false) {
        widget.oldPosition = position.center!;
        widget.hubController.fetchHubs();
      }
    }
    if (widget.streetView && position.zoom! >= 18) {
      setState(() {
        widget.streetView = !widget.streetView;
      });
    } else if (!widget.streetView && position.zoom! <= 18) {
      setState(() {
        widget.streetView = !widget.streetView;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(children: [
        FlutterMap(
          options: MapOptions(
            onPositionChanged: onGeoChanged,
            center: latLng.LatLng(48.85942707304794, 2.350492773209436),
            zoom: 11.0,
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
                urlTemplate: widget.streetView
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
              size: Size(40, 40),
              fitBoundsOptions: FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: widget.hubController.hubs.map((hub) {
                print(hub);
                return Marker(
                    width: 35.0,
                    height: 35.0,
                    point: latLng.LatLng(hub.latitude ?? 0, hub.longitude ?? 0),
                    builder: (ctx) => Container(child: HubPin(hub: hub)));
              }).toList(),
              polygonOptions: PolygonOptions(
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
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0)),
                );
              },
              popupOptions: PopupOptions(
                  popupController: widget.popupController,
                  popupBuilder: (_, marker) => ClipPath(
                        clipper: PopUpClipper(),
                        child: Container(
                          width: 300,
                          height: 175,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Stack(
                            children: [
                              HubPopup(
                                  hub: widget.hubController
                                      .getHubFromMarker(marker)),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () => widget.popupController
                                      .togglePopup(marker),
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
        ),
      ]);
    });
  }
}
