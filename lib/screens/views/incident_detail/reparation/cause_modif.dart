import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/drop_down.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';

class CauseModif extends StatelessWidget {
  final IncidentController incidentController;

  const CauseModif({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Cause de l'incident",
            style: TextStyle(
                color: global_styles.purple,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 20.0),
        Obx(() {
          return DropDown(
              placeholder:
                  incidentController.currentReparation.value.cause.name ??
                      "Pas de cause",
              dropdownItemList: incidentController
                  .currentReparation.value.causelist
                  .map((e) => e.name ?? "Erreur nom cause")
                  .toList(),
              setItem: incidentController.setItemIncidentCause);
        })
      ],
    );
  }
}
