// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/config/colorStatusTypology.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

class BuildPopUpFilters extends StatelessWidget {
  BuildPopUpFilters({Key? key}) : super(key: key);

  final MapBikesController mapBikeController = Get.put(MapBikesController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SimpleDialog(
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        alignment: Alignment.topCenter,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
            width: screenWidth,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.0)),
                color: Colors.white),
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Center(
                child: Text("Filtrer mes vélos",
                    style: TextStyle(
                        color: GlobalStyles.greyText,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 5, 10),
                      child: Text(
                        "Filtres appliqués",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Container(
                  constraints: BoxConstraints(maxHeight: screenHeight * 0.15),
                  child: Expanded(
                      child: Scrollbar(
                    isAlwaysShown: true,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Obx(
                          (() => Wrap(
                              spacing: 4.0,
                              direction: Axis.horizontal,
                              children: mapBikeController
                                          .selectedFiltersList.length ==
                                      0
                                  ? [Text("Aucuns groupes séléctionnés")]
                                  : mapBikeController.availableFiltersList
                                      .map((filterLabel) => Obx(() {
                                            if (mapBikeController
                                                .selectedFiltersList
                                                .contains(filterLabel)) {
                                              return BuildButtonSelectedFilter(
                                                  text: filterLabel,
                                                  setFilters: mapBikeController
                                                      .setFilters);
                                            }
                                            return SizedBox(
                                              height: 0,
                                              width: 0,
                                            );
                                          }))
                                      .toList())),
                        )
                      ],
                    ),
                  ))),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
                    child: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Wrap(
                      spacing: 4.0,
                      direction: Axis.horizontal,
                      children: mapBikeController.availableStatus
                          .map((statusLabel) => Obx(() {
                                return BuildButtonStatus(
                                  label: statusLabel,
                                  setFilters: mapBikeController.setStatus,
                                  isSelected: mapBikeController
                                      .selectedStatusList
                                      .contains(statusLabel),
                                );
                              }))
                          .toList()),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 10),
                    child: Text(
                      "Groupes",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ]),
              Container(
                  child: Expanded(
                      child: Scrollbar(
                isAlwaysShown: true,
                child: ListView(
                  children: [
                    Wrap(
                        spacing: 4.0,
                        direction: Axis.horizontal,
                        children:
                            mapBikeController.availableFiltersList.length == 0
                                ? [Text("Aucun filtre disponible")]
                                : mapBikeController.availableFiltersList
                                    .map((filterLabel) => Obx(() {
                                          return BuildButtonFilter(
                                              label: filterLabel,
                                              setFilters:
                                                  mapBikeController.setFilters,
                                              isSelected: mapBikeController
                                                  .selectedFiltersList
                                                  .contains(filterLabel));
                                        }))
                                    .toList()),
                  ],
                ),
              )))
            ]),
          )
        ]);
  }
}

class BuildButtonFilter extends StatelessWidget {
  const BuildButtonFilter(
      {Key? key,
      required this.label,
      required this.setFilters,
      required this.isSelected})
      : super(key: key);

  final String label;
  final Function setFilters;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
        padding: EdgeInsets.all(0),
        labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        label: Text(label,
            style: TextStyle(
                color:
                    isSelected ? Colors.white : GlobalStyles.backgroundDarkGrey,
                fontSize: 12.0,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        shape: StadiumBorder(
            side:
                BorderSide(color: GlobalStyles.backgroundDarkGrey, width: 1.5)),
        onSelected: (bool value) => setFilters(value, label),
        checkmarkColor: GlobalStyles.blue,
        showCheckmark: false,
        selected: isSelected,
        selectedColor: GlobalStyles.backgroundDarkGrey,
        pressElevation: 0.0);
  }
}

class BuildButtonStatus extends StatelessWidget {
  const BuildButtonStatus(
      {Key? key,
      required this.label,
      required this.setFilters,
      required this.isSelected})
      : super(key: key);

  final String label;
  final Function setFilters;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
        padding: EdgeInsets.all(0),
        labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        label: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : colorStatusTypology[label],
                fontSize: 12.0,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        shape: StadiumBorder(
            side: BorderSide(color: colorStatusTypology[label], width: 1.5)),
        onSelected: (bool value) => setFilters(value, label),
        checkmarkColor: colorStatusTypology[label],
        showCheckmark: false,
        selected: isSelected,
        selectedColor: colorStatusTypology[label],
        pressElevation: 0.0);
  }
}

class BuildButtonSelectedFilter extends StatelessWidget {
  final String text;
  final Function setFilters;

  const BuildButtonSelectedFilter(
      {Key? key, required this.text, required this.setFilters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
        padding: EdgeInsets.all(0),
        labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        label: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(text,
              style: TextStyle(
                  color: GlobalStyles.backgroundDarkGrey,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          Icon(
            Icons.close,
            size: 12,
          )
        ]),
        backgroundColor: Colors.white,
        shape: StadiumBorder(
            side:
                BorderSide(color: GlobalStyles.backgroundDarkGrey, width: 1.5)),
        onSelected: (bool value) => setFilters(false, text),
        checkmarkColor: GlobalStyles.blue,
        showCheckmark: true,
        selected: false,
        selectedColor: Colors.white,
        pressElevation: 0.0);
  }
}
