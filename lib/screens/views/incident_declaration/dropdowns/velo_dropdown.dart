import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/disabled_drop_down.dart';
import 'package:velyvelo/components/drop_down.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/json_usefull.dart';

class VeloDropdown extends StatelessWidget {
  final LoginController loginController;
  final IncidentDeclarationController declarationController;
  final IdAndName? velo;

  const VeloDropdown(
      {super.key,
      required this.loginController,
      required this.declarationController,
      this.velo});

  @override
  Widget build(BuildContext context) {
    return velo != null
        // If the velo is already selected (obx probleme if use in)
        ? DisabledDropDown(placeholder: velo!.name ?? "Erreur nom groupe")
        : Obx(() {
            // All users can see this field
            // If velo is loading OR group is not selected
            if (declarationController.infosSelection.value.infoVelo.isLoading ||
                declarationController.infosSelection.value.infoGroup.selected ==
                    null) {
              return DisabledDropDown(placeholder: "Velo");
            }

            // Has access
            return DropDown(
              placeholder: "Velo",
              dropdownItemList: declarationController
                  .infosSelection.value.infoVelo.listOptions
                  .map((e) => e.name ?? "Erreur nom groupe")
                  .toList(),
              setItem: (value) => {declarationController.setVeloLabel(value)},
            );
          });
  }
}
