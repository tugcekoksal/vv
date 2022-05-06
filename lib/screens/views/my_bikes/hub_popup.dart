// Vendor
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Controllers
import 'package:velyvelo/models/hubs/hub_map.dart';

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_pin,
            color: GlobalStyles.greyText,
            size: 20,
          ),
          const SizedBox(width: 5),
          Flexible(
              child: Text(hub.adresse == "" ? "Pas d'adresse" : hub.adresse,
                  overflow: TextOverflow.ellipsis)),
          GestureDetector(
            onTap: () => {
              Clipboard.setData(ClipboardData(text: hub.adresse)).then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Address copied to clipboard"))))
            },
            child: Icon(
              Icons.copy,
              color: GlobalStyles.greyText,
              size: 20,
            ),
          )
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
