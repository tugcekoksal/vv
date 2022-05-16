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
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

class IncidentDeclarationInformationsContainer extends StatelessWidget {
  final LoginController loginController;
  final String? clientLabel;
  final String? groupLabel;
  final String? veloLabel;

  const IncidentDeclarationInformationsContainer(
      {Key? key,
      required this.loginController,
      required this.clientLabel,
      required this.groupLabel,
      required this.veloLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Informations",
            style: TextStyle(
                color: GlobalStyles.greyText,
                fontSize: 19.0,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10.0),
          // Select client for declaration incident (only for tech and admin)
          IncidentClientDropdown(
              clientLabel: clientLabel, loginController: loginController),
          SizedBox(height: 10.0),
          Obx(() {
            // If it is a simple user, can't access to the group selection,
            // the others can (even super user which can have one or multiple groups)
            if (loginController.isUser.value) {
              return SizedBox();
            }

            // If the group label is already filled
            if (groupLabel != null) {
              // Fill the controller value for the declaration
              incidentDeclarationController.informations["Groupe"] =
                  groupLabel!;
              return BuildDisabledDropDown(placeholder: groupLabel!);
            }

            // If the group labels are loading
            // OR If the client label is not selected
            if (incidentDeclarationController.isLoadingLabelGroup.value) {
              return BuildDisabledDropDown(placeholder: "Groupe");
            }
            if (!incidentDeclarationController.clientLabelPicked.value) {
              return BuildDisabledDropDown(placeholder: "Groupe");
            }

            // User has acces, the groups are loaded, the client label
            // is selected and the group label is not previously filled
            return BuildDropDown(
                placeholder: "Groupe",
                dropdownItemList:
                    incidentDeclarationController.dropdownItemGroupListNames,
                setItem: incidentDeclarationController.setGroupLabel);
          }),
          SizedBox(height: 10.0),
          Obx(() {
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
          }),
          SizedBox(height: 10.0),
          Obx(() {
            if (incidentDeclarationController.veloFormNotCompleted.value !=
                "") {
              return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      incidentDeclarationController.veloFormNotCompleted.value,
                      style: TextStyle(
                          color: GlobalStyles.orange,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500)),
                ),
              );
            } else {
              return SizedBox();
            }
          }),
          if (loginController.isTech.value)
            Obx(() {
              return Row(
                children: [
                  Checkbox(
                      value: incidentDeclarationController
                          .technicianSelfAttributeIncident.value,
                      onChanged: (value) => {
                            incidentDeclarationController
                                .technicianSelfAttributeIncident(value),
                          }), // ICI
                  Text("Attribuer l'incident à mon profil")
                ],
              );
            }),
        ],
      ),
    );
  }
}
