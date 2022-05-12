import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';

// Controllers
import 'package:velyvelo/screens/views/incident_detail/reparation/photos_modif.dart';
import 'package:velyvelo/screens/views/incident_detail/reparation/pieces_modif.dart';

// Components
import 'package:velyvelo/screens/views/incident_detail/reparation/statut_velo_modif.dart';

GlobalKey keyWidget = GlobalKey();

class ReparationContainer extends StatelessWidget {
  final LoginController loginController;
  final IncidentController incidentController;

  ReparationContainer(
      {Key? key,
      required this.loginController,
      required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget gotoWidget = SizedBox(height: 0, width: 0, key: keyWidget);
    incidentController.fetchPieceFromType();
    // incidentController.currentReparation.refresh();
    return Obx(() {
      if (loginController.isAdminOrTech.value) {
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
                Text("Informations de réparation",
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 25.0),
                // Handler of photos adding and photos listing for the reparation
                PhotosModif(incidentController: incidentController),
                const SizedBox(height: 25.0),
                // Handler of is functionnal velo or status name of the velo
                StatutVeloModif(incidentController: incidentController),
                SizedBox(height: 25.0),
                // Handler of the selection of a piece for reparation
                // and of the listing and deletion of selected pieces
                PiecesModif(incidentController: incidentController),
                Text("Commentaire",
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 25.0),
                TextField(
                  onTap: () =>
                      {Scrollable.ensureVisible(keyWidget.currentContext!)},
                  controller:
                      incidentController.currentReparation.value.commentary,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: false,
                  minLines: 5,
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: GlobalStyles.backgroundLightGrey,
                            width: 4.0),
                        borderRadius: BorderRadius.circular(15.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: GlobalStyles.backgroundLightGrey,
                            width: 4.0),
                        borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: GlobalStyles.backgroundLightGrey,
                            width: 4.0),
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  style: TextStyle(
                      color: GlobalStyles.greyTextInput,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
                gotoWidget
                // Obx(() {
                //   if (incidentController.error.value == "")
                //     return SizedBox(
                //       height: MediaQuery.of(context).viewInsets.bottom,
                //     );
                //   return SizedBox.expand();
                // }),
              ],
            ));
      } else {
        return SizedBox();
      }
    });
  }
}
