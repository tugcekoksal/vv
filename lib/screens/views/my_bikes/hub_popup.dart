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
import 'package:velyvelo/models/hubs/hub_map.dart';
import 'package:velyvelo/screens/views/my_bikes/pin.dart';
import 'package:velyvelo/screens/views/my_bikes/usefull.dart';

class HubPopup extends StatelessWidget {
  final HubModel hub;

  HubPopup({Key? key, required this.hub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
          child: Text(hub.groupName ?? "Pas de nom de groupe",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      Text(
        hub.clientName ?? "Pas de nom de client",
        style: TextStyle(fontSize: 12),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.location_pin,
            color: GlobalStyles.greyText,
            size: 20,
          ),
          Flexible(
              child: Text(hub.adresse ?? "Pas d'adresse",
                  overflow: TextOverflow.ellipsis)),
          Icon(
            Icons.copy,
            color: GlobalStyles.greyText,
            size: 20,
          ),
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        children: [
          Text(
            "Vous avez ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            hub.reparations.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: GlobalStyles.yellow),
          ),
          Text(
            " réparations à effectuer.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.people,
            color: GlobalStyles.greyText,
            size: 20,
          ),
          Text(hub.users.toString()),
          Image.asset(
            "assets/pins/green_pin.png",
            width: 30,
          ),
          Text(
            hub.bikeParked.toString(),
            style: TextStyle(color: GlobalStyles.green),
          ),
          Image.asset(
            "assets/pins/blue_pin.png",
            width: 30,
          ),
          Text(
            hub.bikeUsed.toString(),
            style: TextStyle(color: GlobalStyles.blue),
          ),
          Image.asset(
            "assets/pins/orange_pin.png",
            width: 30,
          ),
          Text(
            hub.bikeRobbed.toString(),
            style: TextStyle(color: GlobalStyles.orange),
          ),
        ],
      ),
    ]);
  }
}
