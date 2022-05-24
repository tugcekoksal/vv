// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/drop_down.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers

class PiecesModif extends StatelessWidget {
  final IncidentController incidentController;
  final ScrollController scrollController = ScrollController();

  PiecesModif({Key? key, required this.incidentController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pieces",
            style: TextStyle(
                color: global_styles.purple,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10.0),
        const Text("Séléctionner une pièce",
            style: TextStyle(
                color: global_styles.greyText,
                fontSize: 15.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 25.0),
        Obx(() {
          return Column(
            children: [
              DropDown(
                placeholder: incidentController
                    .currentReparation.value.typeIntervention.name,
                dropdownItemList: incidentController
                    .currentReparation.value.typeInterventionList
                    .map((intervention) => intervention.name)
                    .toList(),
                setItem: incidentController.setTypeIntervention,
              ),
              const SizedBox(height: 10.0),
              DropDown(
                placeholder: incidentController
                    .currentReparation.value.typeReparation.name,
                dropdownItemList: incidentController
                    .currentReparation.value.typeReparationList
                    .map((reparation) => reparation.name)
                    .toList(),
                setItem: incidentController.setTypeReparation,
              ),
              const SizedBox(height: 10.0),
              Obx(() {
                return DropDown(
                  placeholder: "Pièce",
                  dropdownItemList: incidentController
                      .currentReparation.value.piecesList
                      .map((piece) => piece.name)
                      .toList(),
                  setItem: incidentController.setPiece,
                );
              }),
              const SizedBox(height: 25.0),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    incidentController.addPiece();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: global_styles.blue,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 12.0),
                    child: const Text("Ajouter la pièce",
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
        const Text("Mes pièces",
            style: TextStyle(
                color: global_styles.greyText,
                fontSize: 15.0,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Obx(() {
          return incidentController
                  .currentReparation.value.selectedPieces.isEmpty
              ? const ListTile(title: Text("Aucunes pièces sélectionnées"))
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
                                  child: Text(incidentController
                                      .currentReparation
                                      .value
                                      .selectedPieces[index]
                                      .name)),
                              IconButton(
                                  onPressed: () => {
                                        incidentController
                                            .removePieceFromList(index)
                                      },
                                  icon: const Icon(Icons.delete))
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
