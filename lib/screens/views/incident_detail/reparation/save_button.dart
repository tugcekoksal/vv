// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/screens/views/incident_detail/header_container.dart';
import 'package:velyvelo/screens/views/incident_detail/informations_container.dart';
import 'package:velyvelo/screens/views/incident_detail/reparation/reparation_container.dart';
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

// Service Url
import 'package:velyvelo/services/http_service.dart';

// Components
import 'package:velyvelo/components/BuildShowImageFullSlider.dart';

class SaveButton extends StatelessWidget {
  final IncidentController incidentController;

  const SaveButton({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        var snackBar = SnackBar(
          content: Text('Votre demande est en cours de traitement...'),
          backgroundColor: GlobalStyles.blue,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await incidentController.sendReparationUpdate();

        ScaffoldMessenger.of(context).clearSnackBars();
        if (incidentController.error.value == "") {
          snackBar = SnackBar(
            content: Text('Vos informations ont bien été sauvegardées.'),
            backgroundColor: Color(0xff46b594),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          snackBar = SnackBar(
            content: Text('Une erreur est survenue, vérfiez votre réseau.'),
            backgroundColor: GlobalStyles.orange,
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
                offset: Offset(3, 0),
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0))),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
        child: Text("Enregistrer mes modifications",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: GlobalStyles.blue,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
