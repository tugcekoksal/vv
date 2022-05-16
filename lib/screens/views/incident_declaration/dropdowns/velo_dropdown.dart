import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/BuildDisabledDropDown.dart';
import 'package:velyvelo/components/BuildDropDown.dart';
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/utf8_convert.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';

class VeloDropdown extends StatelessWidget {
  final LoginController loginController;
  final IncidentDeclarationController declarationController;
  final IdAndName? velo;

  const VeloDropdown(
      {Key? key,
      required this.loginController,
      required this.declarationController,
      this.velo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // All users can see this field

      // If the velo is already selected
      if (velo != null) {
        return BuildDisabledDropDown(placeholder: velo!.name);
      }

      // If velo is loading OR group is not selected
      if (declarationController.infosSelection.value.infoVelo.isLoading ||
          declarationController.infosSelection.value.infoGroup.selected ==
              null) {
        return BuildDisabledDropDown(placeholder: "Velo");
      }

      // Has access
      return BuildDropDown(
        placeholder: "Velo",
        dropdownItemList: declarationController
            .infosSelection.value.infoVelo.listOptions
            .map((e) => utf8convert(e.name))
            .toList(),
        setItem: (value) => {declarationController.setVeloLabel(value)},
      );
    });
  }
}