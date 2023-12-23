import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/disabled_drop_down.dart';
import 'package:velyvelo/components/drop_down.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/json_usefull.dart';

class GroupDropDown extends StatelessWidget {
  final LoginController loginController;
  final IncidentDeclarationController declarationController;
  final IdAndName? group;

  const GroupDropDown(
      {super.key,
      required this.loginController,
      required this.declarationController,
      this.group});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Simple user does not have access
      if (loginController.isUser.value) {
        return const SizedBox();
      }

      // If the group is already selected
      if (group != null) {
        return DisabledDropDown(
            placeholder: group!.name ?? "Erreur nom de groupe");
      }

      // If group is loading OR client is not selected
      if (declarationController.infosSelection.value.infoGroup.isLoading ||
          declarationController.infosSelection.value.infoClient.selected ==
              null) {
        return DisabledDropDown(placeholder: "Groupe");
      }
      // Has access
      return DropDown(
        placeholder: "Groupe",
        dropdownItemList: declarationController
            .infosSelection.value.infoGroup.listOptions
            .map((e) => e.name ?? "Erreur nom groupe")
            .toList(),
        setItem: (value) => {declarationController.setGroupLabel(value)},
      );
    });
  }
}
