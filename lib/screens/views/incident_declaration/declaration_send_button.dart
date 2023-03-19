import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/bike_provider/bike_profile_provider.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/helpers/logger.dart';

class DeclarationSendButton extends ConsumerWidget {
  final IncidentDeclarationController declarationController =
      Get.put(IncidentDeclarationController());
  final log = logger(DeclarationSendButton);
  DeclarationSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        // Dismiss keyboard on button click
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).clearSnackBars();

        if (declarationController.infosSelection.value.infoVelo.selected ==
                null ||
            declarationController
                    .infosSelection.value.infoVelo.selected!.name ==
                "--Velos--" ||
            declarationController
                    .infosSelection.value.infoVelo.selected!.name ==
                "--Batteries--") {
          declarationController.errors.update((val) {
            val?.veloError = "Le champ vélo n'est pas renseigné";
          });
          const snackBar = SnackBar(
              content: Text('Certains champs requis ne sont pas remplis.'),
              backgroundColor: Colors.red);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        } else {
          declarationController.errors.update((val) {
            val?.veloError = "";
          });
        }

        bool isSent = await declarationController.sendIncident(null);
        if (isSent) {
          try {
            ref.read(bikeProfileProvider).fetchUserBike(
                veloPk: declarationController
                        .infosSelection.value.infoVelo.selected!.id ??
                    -1);
          } catch (e) {
            log.e(e);
          }
          Future.delayed(const Duration(milliseconds: 200),
              () => {Navigator.of(context).pop()});
        } else {
          const snackBar = SnackBar(
              content: Text('Certains champs requis ne sont pas remplis.'),
              backgroundColor: Colors.red);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
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
                  offset: const Offset(3, 0),
                )
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0))),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
          child: const Text("Envoyer ma déclaration",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: global_styles.blue,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
