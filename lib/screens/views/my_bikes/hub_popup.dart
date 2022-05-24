// Vendor
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

// Controllers
import 'package:velyvelo/models/hubs/hub_map.dart';

class HubPopup extends StatelessWidget {
  final HubModel hub;

  const HubPopup({Key? key, required this.hub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
          child: Text(hub.groupName ?? "Pas de nom de groupe",
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      Text(
        hub.clientName ?? "Pas de nom de client",
        style: const TextStyle(fontSize: 12),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_pin,
            color: global_styles.greyText,
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
                      const SnackBar(
                          content:
                              Text("Adresse copiée dans le presse-papier."))))
            },
            child: const Icon(
              Icons.copy,
              color: global_styles.greyText,
              size: 20,
            ),
          )
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      Row(
        children: [
          const Text(
            "Vous avez ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            hub.reparations.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: global_styles.yellow),
          ),
          const Text(
            " réparations à effectuer.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.people,
            color: global_styles.greyText,
            size: 20,
          ),
          Text(hub.users.toString()),
          Image.asset(
            "assets/pins/green_pin.png",
            width: 30,
          ),
          Text(
            hub.bikeParked.toString(),
            style: const TextStyle(color: global_styles.green),
          ),
          Image.asset(
            "assets/pins/blue_pin.png",
            width: 30,
          ),
          Text(
            hub.bikeUsed.toString(),
            style: const TextStyle(color: global_styles.blue),
          ),
          Image.asset(
            "assets/pins/orange_pin.png",
            width: 30,
          ),
          Text(
            hub.bikeRobbed.toString(),
            style: const TextStyle(color: global_styles.orange),
          ),
        ],
      ),
    ]);
  }
}
