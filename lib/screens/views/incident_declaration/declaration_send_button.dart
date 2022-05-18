import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/bike_controller.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';

class DeclarationSendButton extends StatelessWidget {
  final IncidentDeclarationController declarationController =
      Get.put(IncidentDeclarationController());

  DeclarationSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print("ON SEND OU QUOI");
        FocusManager.instance.primaryFocus?.unfocus();
        // Dismiss keyboard on button click
        // var currentFocus = FocusScope.of(context);
        // if (!currentFocus.hasPrimaryFocus) {
        //   currentFocus.unfocus();
        // }

        if (declarationController.infosSelection.value.infoVelo.selected ==
            null) {
          declarationController.errors.update((val) {
            val?.veloError = "Le champ vélo n'est pas renseigné";
          });
          return;
        } else {
          declarationController.errors.update((val) {
            val?.veloError = "";
          });
        }

        bool isSent = await declarationController.sendIncident(null);
        if (isSent) {
          try {
            Get.find<BikeController>().fetchUserBike(declarationController
                .infosSelection.value.infoVelo.selected!.id);
          } catch (e) {}
          Future.delayed(
              Duration(milliseconds: 200),
              () => {
                    // Get.delete<IncidentDeclarationController>(),
                    Navigator.of(context).pop()
                  });
        }
        // if (incidentDeclarationController.isFormUncompleted.value != "" ||
        //     !incidentDeclarationController.bikeLabelPicked.value) {
        //   print(
        //       "error value ${incidentDeclarationController.isFormUncompleted.value}");
        //   showIncidentSendingFeedback(
        //       context, "Un champ n'est pas renseigné.", GlobalStyles.orange);
        // } else {
        //   showIncidentSendingFeedback(context,
        //       "Vos incidents ont été ajouté avec succès.", GlobalStyles.green);

        //   if (widget.veloPk != null) {
        //     BikeController bikeController = Get.put(BikeController());
        //     bikeController.fetchUserBike(widget.veloPk!);
        //   }

        // Return to incidents page after a delay (to read pop up)

        // }
      },
      child: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 3,
                  offset: Offset(3, 0),
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0))),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
          child: Text("Envoyer ma déclaration",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: GlobalStyles.blue,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
