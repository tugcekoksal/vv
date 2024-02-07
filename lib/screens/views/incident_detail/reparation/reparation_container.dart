import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/screens/views/incident_detail/reparation/cause_modif.dart';

// Controllers
import 'package:velyvelo/screens/views/incident_detail/reparation/photos_modif.dart';
import 'package:velyvelo/screens/views/incident_detail/reparation/pieces_modif.dart';

// Components
import 'package:velyvelo/screens/views/incident_detail/reparation/statut_velo_modif.dart';

GlobalKey keyWidget = GlobalKey();

class CommentaryModif extends StatelessWidget {
  final bool disabled;
  final IncidentController incidentController;
  final bool isTech;

  const CommentaryModif(
      {super.key,
      required this.disabled,
      required this.incidentController,
      required this.isTech});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Commentaire ${isTech ? "technicien" : "admin"}",
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: global_styles.purple,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 25.0),
        if (disabled &&
            isTech &&
            incidentController.currentReparation.value.commentaryTech.text ==
                "")
          const Text(
            "Pas de commentaire associé",
            textAlign: TextAlign.left,
          )
        else
          TextField(
            maxLength: 500,
            enabled: !disabled,
            onTap: () => {Scrollable.ensureVisible(keyWidget.currentContext!)},
            controller: isTech
                ? incidentController.currentReparation.value.commentaryTech
                : incidentController.currentReparation.value.commentaryAdmin,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            autofocus: false,
            minLines: 5,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: global_styles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: global_styles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: global_styles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            style: const TextStyle(
                color: global_styles.greyTextInput,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}

class ReparationContainer extends StatelessWidget {
  final LoginController loginController;
  final IncidentController incidentController;

  const ReparationContainer(
      {super.key,
      required this.loginController,
      required this.incidentController});

  String commentaryOrEmpty(String text) {
    if (text == "") {
      return "Pas de commentaire associé";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    Widget gotoWidget = SizedBox(height: 0, width: 0, key: keyWidget);
    incidentController.fetchPieceFromType();
    bool disabled = loginController.userTypeFetched.userType == "Technicien" &&
        (incidentController.currentReparation.value.statusBike == "Terminé" ||
            incidentController.currentReparation.value.statusBike == "Clôturé");
    // incidentController.currentReparation.refresh();
    return Obx(() {
      if (loginController.userTypeFetched.userType == "Technicien" ||
          loginController.userTypeFetched.userType == "Admin") {
        return Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title of the reparation container
                const Text("Informations de réparation",
                    style: TextStyle(
                        color: global_styles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 25.0),
                Text(
                    textAlign: TextAlign.left,
                    "Commentaire ${loginController.userTypeFetched.userType == "Technicien" ? "admin" : "technicien"}",
                    style: const TextStyle(
                        color: global_styles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 25.0),
                Text(loginController.userTypeFetched.userType == "Technicien"
                    ? commentaryOrEmpty(incidentController
                        .currentReparation.value.commentaryAdmin.text)
                    : commentaryOrEmpty(incidentController
                        .currentReparation.value.commentaryTech.text)),
                const SizedBox(height: 25.0),

                // Cause status of incident
                CauseModif(
                    incidentController: incidentController, disabled: disabled),
                const SizedBox(height: 25.0),
                // Handler of photos adding and photos listing for the reparation
                PhotosModif(
                    incidentController: incidentController, disabled: disabled),
                const SizedBox(height: 25.0),
                // Handler of the selection of a piece for reparation
                // and of the listing and deletion of selected pieces
                PiecesModif(
                    incidentController: incidentController, disabled: disabled),
                CommentaryModif(
                  disabled: disabled,
                  incidentController: incidentController,
                  isTech:
                      loginController.userTypeFetched.userType == "Technicien",
                ),
                gotoWidget,
                // Handler of is functionnal velo or status name of the velo
                const SizedBox(height: 25.0),
                StatutVeloModif(
                    incidentController: incidentController, disabled: disabled),
                const SizedBox(height: 25.0),
              ],
            ));
      } else {
        return const SizedBox();
      }
    });
  }
}
