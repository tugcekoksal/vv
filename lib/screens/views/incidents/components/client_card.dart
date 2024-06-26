import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/models/incident/client_card_model.dart';

class ClientCard extends StatelessWidget {
  final ClientCardModel client;
  final bool isTech;

  const ClientCard({super.key, required this.client, required this.isTech});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
            bottom: 4.0, top: 4.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(children: [
          Text(client.name,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(
            client.label,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Flexible(
                  child: Text(client.address, overflow: TextOverflow.ellipsis)),
              GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: client.address)).then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Adresse copiée dans le presse-papier."))));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Icon(
                      Icons.copy,
                      color: global_styles.greyText,
                      size: 20,
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isTech
                  ? const Text(
                      "Vous avez ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const SizedBox(),
              Text(
                client.nbReparation.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: global_styles.yellow),
              ),
              const Flexible(
                  child: Text(
                " réparations à effectuer.",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ]));
  }
}
