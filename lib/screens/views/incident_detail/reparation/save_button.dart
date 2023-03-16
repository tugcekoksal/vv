// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
// RichText(
//   text: TextSpan(
//     text: 'Hello ',
//     style: DefaultTextStyle.of(context).style,
//     children: const <TextSpan>[
//       TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
//       TextSpan(text: ' world!'),
//     ],
//   ),
// )

enum TechnicienPopupType { termine, secondPassage, message }

Widget buttonPopup(BuildContext context, String text, Function ontap,
    Color backgroundColor, Color textColor) {
  return GestureDetector(
      onTap: () {
        ontap();
        Navigator.pop(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
                color: textColor != global_styles.greyText
                    ? backgroundColor
                    : textColor,
                width: 2),
            borderRadius: BorderRadius.circular(10.0)),
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor, fontSize: 16.0, fontWeight: FontWeight.w700)),
      ));
}

void technicienPopup(BuildContext oldcontext, TechnicienPopupType typePopup,
    Function sendReparation) {
  Color popupColor = typePopup == TechnicienPopupType.termine
      ? global_styles.green
      : typePopup == TechnicienPopupType.secondPassage
          ? global_styles.yellow
          : global_styles.orange;

  showDialog(
      useSafeArea: false,
      context: oldcontext,
      builder: (BuildContext context) => GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              color: Colors.black38,
              child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.5,
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.warning_amber_outlined,
                                    color: popupColor, size: 80),
                                Text("Avertissement",
                                    style: TextStyle(
                                        color: popupColor, fontSize: 18))
                              ],
                            ),
                            if (typePopup == TechnicienPopupType.termine)
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: 'Une fois la réparation enregistrée ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Terminé',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: popupColor)),
                                    const TextSpan(text: ' , vous ne pourrez '),
                                    const TextSpan(
                                        text: 'plus',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const TextSpan(text: ' apporter '),
                                    const TextSpan(
                                        text: 'de modifications.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    if (typePopup !=
                                        TechnicienPopupType.message)
                                      const TextSpan(
                                        text:
                                            "\n\nÊtes-vous sûr de vouloir continuer ?",
                                      ),
                                  ],
                                ),
                              ),
                            if (typePopup == TechnicienPopupType.secondPassage)
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: 'Une fois la réparation enregistrée ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Second passage',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: popupColor)),
                                    const TextSpan(text: ' , vous n\'aurez '),
                                    const TextSpan(
                                        text: 'plus',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const TextSpan(text: ' accès à la '),
                                    const TextSpan(
                                        text: 'réparation',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    if (typePopup !=
                                        TechnicienPopupType.message)
                                      const TextSpan(
                                        text:
                                            "\n\nÊtes-vous sûr de vouloir continuer ?",
                                      ),
                                  ],
                                ),
                              ),
                            if (typePopup == TechnicienPopupType.message)
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: 'Vous devez choisir le statut ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Terminé',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: popupColor)),
                                    const TextSpan(text: ' ou '),
                                    TextSpan(
                                        text: 'Second passage',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: popupColor)),
                                    const TextSpan(
                                        text: ' pour votre réparation.'),
                                  ],
                                ),
                              ),
                            if (typePopup == TechnicienPopupType.message)
                              buttonPopup(context, "Retour", () {},
                                  Colors.white, global_styles.greyText)
                            else
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buttonPopup(context, "Annuler", () {},
                                      Colors.white, global_styles.greyText),
                                  buttonPopup(context, "Confirmer", () {
                                    sendReparation();
                                    print("SEND CONFIRMER");
                                  }, popupColor, Colors.white)
                                ],
                              )
                          ]))))));
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

              incidentController.error.value = "";
              if (incidentController.currentReparation.value.cause.name ==
                  null) {
                incidentController.error.value =
                    "Veuillez renseigner une cause";
                var snackBar = SnackBar(
                  content: Text(incidentController.error.value),
                  backgroundColor: global_styles.orange,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }
              if (incidentController.currentReparation.value.noPieces) {
                incidentController.currentReparation.value.selectedPieces = [];
              } else {
                if (incidentController
                    .currentReparation.value.selectedPieces.isEmpty) {
                  incidentController.error.value =
                      "Veuillez renseigner si des pièces ont été utilisées.";
                  var snackBar = SnackBar(
                    content: Text(incidentController.error.value),
                    backgroundColor: global_styles.orange,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
              }
              if (loginController.isTech.value) {
                if (incidentController.currentReparation.value.statusBike ==
                    "Terminé") {
                  technicienPopup(context, TechnicienPopupType.termine, () {
                    sendReparation(context);
                    print("SEND TERMINE");
                  });
                } else if (incidentController
                        .currentReparation.value.statusBike ==
                    "Second passage") {
                  technicienPopup(context, TechnicienPopupType.secondPassage,
                      () {
                    sendReparation(context);
                    print("SEND SECOND PASSAGE");
                  });
                } else {
                  sendReparation(context);
                  print("SEND ELSE1");
                }
              } else {
                sendReparation(context);
                print("SEND ELSE2");
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
