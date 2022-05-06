// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/config/markersPaths.dart';

// Controllers
import 'package:velyvelo/models/hubs/hub_map.dart';
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
                Container(color: MarkersColor[status], height: 15, width: 15),
          )),
      Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: MarkersColor[status], width: 2)),
          child: Image.asset(MarkersPaths[status])),
    ]);
  }
}

class HubPin extends StatelessWidget {
  final HubPinModel hub;

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
              color: GlobalStyles.yellow,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.black, width: 2)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                HttpService.urlServer + hub.pictureUrl!,
                errorBuilder: (context, child, loadingProgress) => Icon(
                  Icons.other_houses,
                  color: Colors.white,
                ),
                fit: BoxFit.fitHeight,
              )))
    ]);
  }
}
