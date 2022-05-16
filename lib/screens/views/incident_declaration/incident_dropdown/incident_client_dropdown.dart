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

class IncidentClientDropdown extends StatelessWidget {
  final String? clientLabel;
  final LoginController loginController;

  const IncidentClientDropdown(
      {Key? key, required this.clientLabel, required this.loginController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (clientLabel != null)
        incidentDeclarationController.informations["Client"] = clientLabel!;
      if (incidentDeclarationController.isLoadingLabelClient.value &&
          loginController.isAdminOrTech.value) {
        return BuildDisabledDropDown(placeholder: "Client");
      } else if (loginController.isAdminOrTech.value) {
        if (clientLabel != null) {
          return BuildDisabledDropDown(placeholder: clientLabel!);
        }
        return BuildDropDown(
            placeholder: "Client",
            dropdownItemList:
                incidentDeclarationController.dropdownItemClientListNames,
            setItem: incidentDeclarationController.setClientLabel);
      } else {
        return SizedBox();
      }
    });
    // return Obx(() {
    //   // Display nothing if not tech or admin
    //   if (!loginController.isAdminOrTech.value) {
    //     return SizedBox();
    //   }
    //   // Display disabled dropdown when informations are filled
    //   // before user use it (from velo page)
    //   if (clientLabel != null) {
    //     // Fill the controller value for the declaration
    //     incidentDeclarationController.informations["Client"] = clientLabel!;
    //     // Display disabled dropdown
    //     return BuildDisabledDropDown(placeholder: clientLabel!);
    //   }
    //   // User is admin or tech and need to fill the informations (declaration page from incident view)
    //   // but the dropdown is loading
    //   if (incidentDeclarationController.isLoadingLabelClient.value) {
    //     return BuildDisabledDropDown(placeholder: "Client");
    //   }
    //   // the loading is loaded
    //   return BuildDropDown(
    //       placeholder: "Client",
    //       dropdownItemList:
    //           incidentDeclarationController.dropdownItemClientListNames,
    //       setItem: incidentDeclarationController.setClientLabel);
    // });
  }
}
