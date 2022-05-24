import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/config/globalStyles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/screens/views/incident_declaration/dropdowns/client_dropdown.dart';
import 'package:velyvelo/screens/views/incident_declaration/dropdowns/group_dropdown.dart';
import 'package:velyvelo/screens/views/incident_declaration/tech_checkbox.dart';
import 'package:velyvelo/screens/views/incident_declaration/dropdowns/velo_dropdown.dart';

class ErrorContainer extends StatelessWidget {
  final String text;
  const ErrorContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            style: const TextStyle(
                color: global_styles.orange,
                fontSize: 11.0,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class DeclarationInformationContainer extends StatelessWidget {
  final IdAndName? client;
  final IdAndName? group;
  final IdAndName? velo;
  final LoginController loginController = Get.find<LoginController>();
  final IncidentDeclarationController declarationController =
      Get.put(IncidentDeclarationController());

  DeclarationInformationContainer(
      {Key? key, this.client, this.group, this.velo})
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
          const Text(
            "Informations",
            style: TextStyle(
                color: global_styles.greyText,
                fontSize: 19.0,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10.0),
          ClientDropDown(
              loginController: loginController,
              declarationController: declarationController,
              client: client),
          const SizedBox(height: 10.0),
          GroupDropDown(
              loginController: loginController,
              declarationController: declarationController,
              group: group),
          const SizedBox(height: 10),
          VeloDropdown(
              loginController: loginController,
              declarationController: declarationController,
              velo: velo),
          // If no velo is selected show error when trying to declare incident
          Obx(() {
            if (declarationController.errors.value.veloError != "") {
              return ErrorContainer(
                  text: declarationController.errors.value.veloError);
            } else {
              return const SizedBox();
            }
          }),
          const SizedBox(height: 10),
          TechCheckbox(
              loginController: loginController,
              declarationController: declarationController),
        ],
      ),
    );
  }
}
