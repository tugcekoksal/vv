// Vendor
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/carte_provider/carte_hub_provider.dart';

class HubPopup extends StatelessWidget {
  final CarteHubProvider hubs;
  const HubPopup({Key? key, required this.hubs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Flexible(
          child: Text(hubs.hubPopup?.name ?? "Pas de nom de groupe",
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      Text(
        hubs.hubPopup?.clientName ?? "Pas de nom de client",
        style: const TextStyle(fontSize: 12),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Icon(
                Icons.location_pin,
                color: global_styles.greyText,
                size: 20,
              )),
          Flexible(
              child: Text(hubs.hubPopup?.adress ?? "Pas d'adresse",
                  overflow: TextOverflow.ellipsis)),
          GestureDetector(
            onTap: () => {
              Clipboard.setData(ClipboardData(
                      text: hubs.hubPopup?.adress ?? "Pas d'adresse"))
                  .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Adresse copiée dans le presse-papier."))))
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Icon(
                Icons.copy,
                color: global_styles.greyText,
                size: 20,
              ),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Vous avez ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            (hubs.hubPopup?.reparationsNb).toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: global_styles.yellow),
          ),
          const Text(
            " réparations.",
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
          Text((hubs.hubPopup?.usersNb).toString()),
          Image.asset(
            "assets/pins/green_pin.png",
            width: 30,
          ),
          Text(
            (hubs.hubPopup?.parkedNb).toString(),
            style: const TextStyle(color: global_styles.green),
          ),
          Image.asset(
            "assets/pins/blue_pin.png",
            width: 30,
          ),
          Text(
            (hubs.hubPopup?.usedNb).toString(),
            style: const TextStyle(color: global_styles.blue),
          ),
          Image.asset(
            "assets/pins/orange_pin.png",
            width: 30,
          ),
          Text(
            (hubs.hubPopup?.robbedNb).toString(),
            style: const TextStyle(color: global_styles.orange),
          ),
        ],
      ),
      const SizedBox(height: 20)
    ]);
  }
}
