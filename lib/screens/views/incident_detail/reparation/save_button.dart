// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';

Widget _buildConfirmationDialog(
    BuildContext context, Function action, String message) {
  return Container(
    color: Colors.black38,
    child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: const EdgeInsets.all(25),
          child: Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
      const SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              action();
              Navigator.pop(context);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0)),
              child: const Text('Confirmer',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 50),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
              decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(25.0)),
              child: const Text('Annuler',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    ])),
  );
}

void displayPopUpConfirmation(context, Function action, String message) {
  showDialog(
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) =>
          _buildConfirmationDialog(context, action, message));
}

void displayPopUpAlert(context, String message) {
  showDialog(
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black38,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Padding(
                    padding: const EdgeInsets.all(25),
                    child: Text(message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 14.0),
                        decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(25.0)),
                        child: const Text('Annuler',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ])),
        );
      });
}

class SaveButton extends StatelessWidget {
  final IncidentController incidentController;
  final LoginController loginController;

  const SaveButton(
      {Key? key,
      required this.incidentController,
      required this.loginController})
      : super(key: key);

  void sendReparation(context) async {
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
      incidentController
          .fetchAllIncidents(incidentController.incidentsToFetch.value);
      Navigator.pop(context);
    } else {
      snackBar = SnackBar(
        content: Text(incidentController.error.value),
        backgroundColor: global_styles.orange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool disabled = loginController.isTech.value &&
        incidentController.currentReparation.value.statusBike == "Terminé";

    return disabled
        ? const SizedBox()
        : GestureDetector(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();

              if (loginController.isTech.value) {
                if (incidentController.currentReparation.value.statusBike ==
                    "Terminé") {
                  displayPopUpConfirmation(context, () {
                    sendReparation(context);
                  }, "Une réparation avec le statut Terminé ne sera plus modifiable.");
                } else if (incidentController
                        .currentReparation.value.statusBike ==
                    "Second passage") {
                  displayPopUpConfirmation(context, () {
                    sendReparation(context);
                  }, "Une réparation avec le statut Second passage ne sera plus accessible.");
                } else {
                  displayPopUpAlert(context,
                      "Le statut doit être l'un des suivants : Terminé ou Second passage");
                }
              } else {
                sendReparation(context);
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
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
