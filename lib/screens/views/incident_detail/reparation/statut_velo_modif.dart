// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/screens/views/incident_detail/reparation/status_velo_dropdown.dart';

class StatutButton extends StatelessWidget {
  final IncidentController incidentController;
  final bool status;
  final bool isActive;
  final String text;
  final bool disabled;

  const StatutButton(
      {super.key,
      required this.incidentController,
      required this.status,
      required this.isActive,
      required this.text,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!disabled) {
          incidentController.setCurrentDetailBikeStatus(status);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: isActive ? global_styles.backgroundLightGrey : Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
                color: global_styles.backgroundLightGrey, width: 3.0)),
        child: Text(text,
            style: TextStyle(
                color: disabled
                    ? global_styles.lightGreyText
                    : global_styles.greyText,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class StatutVeloModif extends StatelessWidget {
  final IncidentController incidentController;
  final bool disabled;

  const StatutVeloModif(
      {super.key, required this.incidentController, required this.disabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Statut de la réparation",
            style: TextStyle(
                color: global_styles.purple,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        const Text("Le vélo est-il fonctionnel ?",
            style: TextStyle(
                color: global_styles.greyText,
                fontSize: 15.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 20.0),
        Obx(() {
          if (disabled) {
            return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              StatutButton(
                incidentController: incidentController,
                status: true,
                isActive: true,
                text: (incidentController
                            .currentReparation.value.isBikeFunctional ??
                        false)
                    ? "Oui"
                    : "Non",
                disabled: disabled,
              )
            ]);
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatutButton(
                  incidentController: incidentController,
                  status: true,
                  isActive: incidentController
                          .currentReparation.value.isBikeFunctional ??
                      false,
                  text: "Oui",
                ),
                StatutButton(
                  incidentController: incidentController,
                  status: false,
                  isActive: incidentController
                              .currentReparation.value.isBikeFunctional ==
                          null
                      ? false
                      : !incidentController
                          .currentReparation.value.isBikeFunctional!,
                  text: "Non",
                ),
              ],
            );
          }
        }),
        const SizedBox(height: 25.0),
        const Text("Séléctionner le statut de la réparation",
            style: TextStyle(
                color: global_styles.greyText,
                fontSize: 15.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 20.0),
        StatusVeloDropDown(
            incidentController: incidentController, disabled: disabled),
      ],
    );
  }
}
