// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

class SaveButton extends StatelessWidget {
  final IncidentController incidentController;

  const SaveButton({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();

        // var currentFocus = FocusScope.of(context);

        // if (!currentFocus.hasPrimaryFocus) {
        //   currentFocus.unfocus();
        // }

        var snackBar = const SnackBar(
          content: Text('Votre demande est en cours de traitement...'),
          backgroundColor: global_styles.blue,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await incidentController.sendReparationUpdate();

        ScaffoldMessenger.of(context).clearSnackBars();
        if (incidentController.error.value == "") {
          snackBar = const SnackBar(
            content: Text('Vos informations ont bien été sauvegardées.'),
            backgroundColor: Color(0xff46b594),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          snackBar = const SnackBar(
            content: Text('Une erreur est survenue, vérfiez votre réseau.'),
            backgroundColor: global_styles.orange,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
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
        child: const Text("Enregistrer mes modifications",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: global_styles.blue,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
