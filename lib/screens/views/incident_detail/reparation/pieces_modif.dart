// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/drop_down.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers

class PieceSelection extends StatelessWidget {
  final IncidentController incidentController;
  final ScrollController scrollController = ScrollController();

  PieceSelection({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        .currentReparation.value.typeIntervention.name ??
                    "Error type intervention",
                dropdownItemList: incidentController
                    .currentReparation.value.typeInterventionList
                    .map((intervention) =>
                        intervention.name ?? "Error type intervention")
                    .toList(),
                setItem: incidentController.setTypeIntervention,
              ),
              const SizedBox(height: 10.0),
              DropDown(
                placeholder: incidentController
                        .currentReparation.value.typeReparation.name ??
                    "Error type reparation",
                dropdownItemList: incidentController
                    .currentReparation.value.typeReparationList
                    .map((reparation) =>
                        reparation.name ?? "Error type reparation")
                    .toList(),
                setItem: incidentController.setTypeReparation,
              ),
              const SizedBox(height: 10.0),
              Obx(() {
                return DropDown(
                  placeholder: "Pièce",
                  dropdownItemList: incidentController
                      .currentReparation.value.piecesList
                      .map((piece) => piece.name ?? "Error piece name")
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
          if (incidentController
              .currentReparation.value.selectedPieces.isEmpty) {
            return const ListTile(title: Text("Aucunes pièces séléctionnées"));
          } else {
            return SizedBox(
                height: incidentController
                            .currentReparation.value.selectedPieces.length <
                        4
                    ? (incidentController
                            .currentReparation.value.selectedPieces.length) *
                        60
                    : 240,
                child: Scrollbar(
                    thumbVisibility: true,
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
                                child: Text(incidentController.currentReparation
                                        .value.selectedPieces[index].name ??
                                    "Error selected piece name")),
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
          }
        }),
        const SizedBox(height: 25)
      ],
    );
  }
}

class PiecesModif extends StatelessWidget {
  final IncidentController incidentController;

  const PiecesModif({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Pieces",
          style: TextStyle(
              color: global_styles.purple,
              fontSize: 17.0,
              fontWeight: FontWeight.w600)),
      const SizedBox(height: 10.0),
      Obx(() {
        return Row(
          children: [
            Checkbox(
                value: incidentController.currentReparation.value.noPieces,
                onChanged: (value) {
                  incidentController.setNoPieces(value);
                }),
            const Text("Aucunes pièces utilisées")
          ],
        );
      }),
      Obx(() {
        if (incidentController.currentReparation.value.noPieces == false) {
          return PieceSelection(incidentController: incidentController);
        }
        return const SizedBox();
      })
    ]);
  }
}
