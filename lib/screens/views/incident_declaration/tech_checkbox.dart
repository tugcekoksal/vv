import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';

class TechCheckbox extends StatelessWidget {
  final LoginController loginController;
  final IncidentDeclarationController declarationController;

  const TechCheckbox(
      {Key? key,
      required this.loginController,
      required this.declarationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loginController.isTech.value
        ? Obx(() {
            return Row(
              children: [
                Checkbox(
                    value: declarationController.selfAttribute.value,
                    onChanged: (value) => {
                          declarationController.selfAttribute(value),
                        }),
                const Text("Attribuer l'incident à mon profil")
              ],
            );
          })
        : const SizedBox(height: 0, width: 0);
  }
}
