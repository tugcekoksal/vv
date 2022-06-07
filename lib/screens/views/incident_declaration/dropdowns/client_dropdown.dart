import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/disabled_drop_down.dart';
import 'package:velyvelo/components/drop_down.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/json_usefull.dart';

class ClientDropDown extends StatelessWidget {
  final LoginController loginController;
  final IncidentDeclarationController declarationController;
  final IdAndName? client;

  const ClientDropDown(
      {Key? key,
      required this.loginController,
      required this.declarationController,
      this.client})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => declarationController.fetchClientLabels());

    return Obx(() {
      // Tech and admin have access to the client dropdown
      if (!loginController.isAdminOrTech.value) {
        return const SizedBox();
      }

      // If the client is already selected
      if (client != null) {
        return DisabledDropDown(
            placeholder: client!.name ?? "Erreur nom groupe");
      }

      if (declarationController.infosSelection.value.infoClient.isLoading) {
        return DisabledDropDown(placeholder: "Client");
      }
      // Has access
      return DropDown(
        placeholder: "Client",
        dropdownItemList: declarationController
            .infosSelection.value.infoClient.listOptions
            .map((e) => e.name ?? "Erreur nom groupe")
            .toList(),
        setItem: (value) => {declarationController.setClientLabel(value)},
      );
    });
  }
}
