// Vendor
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/BuildDropDown.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/helpers/utf8_convert.dart';

class PiecesModif extends StatelessWidget {
  final IncidentController incidentController;
  final ScrollController scrollController = ScrollController();

  PiecesModif({Key? key, required this.incidentController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GlobalKey> keyGoto = List.generate(3, (index) => GlobalKey());
    List<Widget> gotoWidget = List.generate(
        3, (index) => SizedBox(height: 0, width: 0, key: keyGoto[index]));
    // scrollController.createScrollPosition(
    // ScrollPhysics(), ScrollPosition(), null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pieces",
            style: TextStyle(
                color: GlobalStyles.purple,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10.0),
        Text("Séléctionner une pièce",
            style: TextStyle(
                color: GlobalStyles.greyText,
                fontSize: 15.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 25.0),
        Obx(() {
          return Column(
            children: [
              BuildDropDown(
                placeholder: "Type intervention",
                dropdownItemList: incidentController
                    .currentReparation.value.typeInterventionList
                    .map((intervention) => utf8convert(intervention.name))
                    .toList(),
                setItem: incidentController.setTypeIntervention,
              ),
              const SizedBox(height: 10.0),
              BuildDropDown(
                placeholder: "Type reparation",
                dropdownItemList: incidentController
                    .currentReparation.value.typeReparationList
                    .map((reparation) => utf8convert(reparation.name))
                    .toList(),
                setItem: incidentController.setTypeReparation,
              ),
              const SizedBox(height: 10.0),
              BuildDropDown(
                placeholder: "Pièce",
                dropdownItemList: incidentController
                    .currentReparation.value.piecesList
                    .map((piece) => utf8convert(piece.name))
                    .toList(),
                setItem: incidentController.setPiece,
              ),
              const SizedBox(height: 25.0),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    incidentController.addPiece();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: GlobalStyles.blue,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                    child: Text("Ajouter la pièce",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 40),
        Text("Mes pièces",
            style: TextStyle(
                color: GlobalStyles.greyText,
                fontSize: 15.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Obx(() {
          return incidentController
                      .currentReparation.value.selectedPieces.length ==
                  0
              ? ListTile(title: Text("Aucunes pièces sélectionnées"))
              : SizedBox(
                  height: incidentController
                              .currentReparation.value.selectedPieces.length <
                          4
                      ? (incidentController
                              .currentReparation.value.selectedPieces.length) *
                          60
                      : 240,
                  child: Scrollbar(
                      isAlwaysShown: true,
                      showTrackOnHover: true,
                      controller: scrollController,
                      child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: incidentController
                            .currentReparation.value.selectedPieces.length,
                        itemBuilder: (context, int index) {
                          return ListTile(
                            title: Row(children: [
                              Flexible(
                                  child: Text(utf8convert(incidentController
                                      .currentReparation
                                      .value
                                      .selectedPieces[index]
                                      .name))),
                              IconButton(
                                  onPressed: () => {
                                        incidentController
                                            .removePieceFromList(index)
                                      },
                                  icon: Icon(Icons.delete))
                            ]),
                          );
                        },
                      )));
        }),
        const SizedBox(height: 25)
      ],
    );
  }
}
