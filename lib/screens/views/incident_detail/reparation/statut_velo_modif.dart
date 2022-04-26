// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/screens/views/incident_detail/reparation/status_velo_dropdown.dart';

class StatutButton extends StatelessWidget {
  final IncidentController incidentController;
  final bool status;
  final text;

  const StatutButton(
      {Key? key,
      required this.incidentController,
      required this.status,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => incidentController.setCurrentDetailBikeStatus(status),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
              color: incidentController.currentReparation.value.isBikeFunctional
                  ? GlobalStyles.backgroundLightGrey
                  : Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: GlobalStyles.backgroundLightGrey, width: 3.0)),
          child: Text(text,
              style: TextStyle(
                  color: GlobalStyles.greyText,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ),
      );
    });
  }
}

class StatutVeloModif extends StatelessWidget {
  final IncidentController incidentController;

  const StatutVeloModif({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Statut du vélo",
            style: TextStyle(
                color: GlobalStyles.purple,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Text("Le vélo est-il fonctionnel ?",
            style: TextStyle(
                color: GlobalStyles.greyText,
                fontSize: 15.0,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatutButton(
              incidentController: incidentController,
              status: true,
              text: "Oui",
            ),
            StatutButton(
              incidentController: incidentController,
              status: false,
              text: "Non",
            ),
          ],
        ),
        SizedBox(height: 25.0),
        Text("Séléctionner le statut du vélo",
            style: TextStyle(
                color: GlobalStyles.greyText,
                fontSize: 15.0,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 20.0),
        StatusVeloDropDown(incidentController: incidentController),
      ],
    );
  }
}
