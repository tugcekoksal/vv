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
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

class IncidentGroupDropdown extends StatelessWidget {
  final LoginController loginController;
  final String? groupLabel;

  const IncidentGroupDropdown(
      {Key? key, required this.loginController, required this.groupLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (incidentDeclarationController.clientLabelPicked.value &&
              !loginController.isUser.value ||
          groupLabel != null) {
        if (groupLabel != null) {
          return BuildDisabledDropDown(placeholder: groupLabel!);
        }
        return BuildDropDown(
            placeholder: "Groupe",
            dropdownItemList:
                incidentDeclarationController.dropdownItemGroupListNames,
            setItem: incidentDeclarationController.setGroupLabel);
      } else if (loginController.isUser.value) {
        return SizedBox();
      } else {
        return BuildDisabledDropDown(placeholder: "Groupe");
      }
    });
    // return Obx(() {
    //   // If it is a simple user, can't access to the group selection,
    //   // the others can (even super user which can have one or multiple groups)
    //   if (loginController.isUser.value) {
    //     return SizedBox();
    //   }

    //   // If the group label is already filled
    //   if (groupLabel != null) {
    //     // Fill the controller value for the declaration
    //     incidentDeclarationController.informations["Groupe"] = groupLabel!;
    //     return BuildDisabledDropDown(placeholder: groupLabel!);
    //   }

    //   // If the group labels are loading
    //   // OR If the client label is not selected
    //   if (incidentDeclarationController.isLoadingLabelGroup.value) {
    //     return BuildDisabledDropDown(placeholder: "Groupe");
    //   }
    //   if (!incidentDeclarationController.clientLabelPicked.value) {
    //     return BuildDisabledDropDown(placeholder: "Groupe");
    //   }

    //   // User has acces, the groups are loaded, the client label
    //   // is selected and the group label is not previously filled
    //   return BuildDropDown(
    //       placeholder: "Groupe",
    //       dropdownItemList:
    //           incidentDeclarationController.dropdownItemGroupListNames,
    //       setItem: incidentDeclarationController.setGroupLabel);
    // });
  }
}
