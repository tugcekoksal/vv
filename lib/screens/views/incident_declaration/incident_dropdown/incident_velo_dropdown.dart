// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Components
import 'package:velyvelo/components/BuildDropDown.dart';
import 'package:velyvelo/components/BuildFormIncident.dart';
import 'package:velyvelo/components/BuildFormsDivider.dart';
import 'package:velyvelo/components/BuildDisabledDropDown.dart';
import 'package:velyvelo/controllers/bike_controller.dart';

// Controllers
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/screens/views/incident_declaration/incident_dropdown/incident_client_dropdown.dart';
import 'package:velyvelo/screens/views/incident_declaration/incident_dropdown/incident_group_dropdown.dart';
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

class IncidentVeloDropdown extends StatelessWidget {
  final LoginController loginController;
  final String? veloLabel;

  const IncidentVeloDropdown(
      {Key? key, required this.loginController, required this.veloLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (incidentDeclarationController.groupLabelPicked.value ||
          loginController.isUser.value ||
          veloLabel != null) {
        if (veloLabel != null) {
          return BuildDisabledDropDown(placeholder: veloLabel!);
        }
        return BuildDropDown(
            placeholder: "Vélo",
            dropdownItemList:
                incidentDeclarationController.dropdownItemBikeListNames,
            setItem: incidentDeclarationController.setBikeLabel);
      } else {
        return BuildDisabledDropDown(placeholder: "Vélo");
      }
    });
  }
}
