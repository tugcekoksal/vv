import 'package:flutter/material.dart';
import 'package:velyvelo/models/incident/group_card_model.dart';

class GroupCard extends StatelessWidget {
  final GroupCardModel group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
            bottom: 4.0, top: 4.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(group.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Row(children: [
                Container(
                  width: 3,
                  height: 10,
                  color: Colors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  "${group.nbReparation} incidents",
                  style: const TextStyle(fontSize: 12),
                ),
              ]),
            ],
          ),
          Text(
            group.adresse,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            "${group.nbVelo} vélos à réparer",
            style: const TextStyle(fontSize: 12),
          ),
        ]));
  }
}
