import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/BuildDisabledDropDown.dart';
import 'package:velyvelo/components/BuildDropDown.dart';
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/utf8_convert.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';

class GroupDropDown extends StatelessWidget {
  final LoginController loginController;
  final IncidentDeclarationController declarationController;
  final IdAndName? group;

  const GroupDropDown(
      {Key? key,
      required this.loginController,
      required this.declarationController,
      this.group})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(loginController.isUser.value);
    return Obx(() {
      // Simple user does not have access
      if (loginController.isUser.value) {
        return SizedBox();
      }

      // If the group is already selected
      if (group != null) {
        return BuildDisabledDropDown(placeholder: group!.name);
      }

      // If group is loading OR client is not selected
      if (declarationController.infosSelection.value.infoGroup.isLoading ||
          declarationController.infosSelection.value.infoClient.selected ==
              null) {
        return BuildDisabledDropDown(placeholder: "Groupe");
      }
      // Has access
      return BuildDropDown(
        placeholder: "Groupe",
        dropdownItemList: declarationController
            .infosSelection.value.infoGroup.listOptions
            .map((e) => utf8convert(e.name))
            .toList(),
        setItem: (value) => {declarationController.setGroupLabel(value)},
      );
    });
  }
}
