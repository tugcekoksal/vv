import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/BuildDisabledDropDown.dart';
import 'package:velyvelo/components/BuildDropDown.dart';
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';

class IncidentStatusDropDown extends StatelessWidget {
  final IncidentDeclarationController declarationController;
  final IdAndName? status;

  const IncidentStatusDropDown(
      {Key? key, required this.declarationController, this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100))
        .then((value) => declarationController.fetchClientLabels());

    return Obx(() {
      if (declarationController.incidentTypeSelection.value.isLoading) {
        return BuildDisabledDropDown(placeholder: "Client");
      }
      // Has access
      return BuildDropDown(
        placeholder: "Client",
        dropdownItemList: declarationController
            .infosSelection.value.infoClient.listOptions
            .map((e) => e.name)
            .toList(),
        setItem: (value) => {declarationController.setClientLabel(value)},
      );
    });
  }
}
