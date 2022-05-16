import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/BuildDisabledDropDown.dart';
import 'package:velyvelo/components/BuildDropDown.dart';
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/utf8_convert.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';

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
    Future.delayed(Duration(milliseconds: 100))
        .then((value) => declarationController.fetchClientLabels());

    return Obx(() {
      // Tech and admin have access to the client dropdown
      if (!loginController.isAdminOrTech.value) {
        return SizedBox();
      }

      // If the client is already selected
      if (client != null) {
        return BuildDisabledDropDown(placeholder: client!.name);
      }

      if (declarationController.infosSelection.value.infoClient.isLoading) {
        return BuildDisabledDropDown(placeholder: "Client");
      }
      // Has access
      return BuildDropDown(
        placeholder: "Client",
        dropdownItemList: declarationController
            .infosSelection.value.infoClient.listOptions
            .map((e) => utf8convert(e.name))
            .toList(),
        setItem: (value) => {declarationController.setClientLabel(value)},
      );
    });
  }
}
