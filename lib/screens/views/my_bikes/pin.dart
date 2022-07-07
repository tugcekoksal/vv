// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/config/markers_paths.dart';
import 'package:velyvelo/models/carte/hub_map_model.dart';

// Controllers
import 'package:velyvelo/services/http_service.dart';

class Pin extends StatelessWidget {
  final String status;

  const Pin({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Positioned(
          top: 24,
          left: 10.5,
          child: Transform.rotate(
            angle: 40,
            child:
                Container(color: markersColor[status], height: 15, width: 15),
          )),
      Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: markersColor[status], width: 2)),
          child: Image.asset(markersPaths[status])),
    ]);
  }
}

class HubPin extends StatelessWidget {
  final HubMapModel hub;

  const HubPin({Key? key, required this.hub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Positioned(
          top: 24,
          left: 10.5,
          child: Transform.rotate(
            angle: 40,
            child: Container(color: Colors.black, height: 15, width: 15),
          )),
      Container(
          width: 35,
          height: 35,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: global_styles.yellow,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.black, width: 2)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                HttpService.urlServer + (hub.pictureUrl ?? ""),
                errorBuilder: (context, child, loadingProgress) => const Icon(
                  Icons.other_houses,
                  color: Colors.white,
                ),
                fit: BoxFit.fitHeight,
              )))
    ]);
  }
}
