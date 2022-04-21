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

    return SimpleDialog(backgroundColor: Colors.transparent, children: [
      Container(
          width: screenWidth * 0.80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Text("Filtrer par groupe",
                  style: TextStyle(
                      color: GlobalStyles.greyText,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 25.0),
            Wrap(
                spacing: 8.0,
                direction: Axis.horizontal,
                children: mapBikeController.availableFiltersList.length == 0
                    ? [Text("Aucun filtre disponible")]
                    : mapBikeController.availableFiltersList
                        .map((filterLabel) => Obx(() {
                              return BuildButtonFilter(
                                  label: filterLabel,
                                  setFilters: mapBikeController.setFilters,
                                  isSelected: mapBikeController
                                      .selectedFiltersList
                                      .contains(filterLabel),
                                  screenWidth: screenWidth);
                            }))
                        .toList()),
            Wrap(
                spacing: 8.0,
                direction: Axis.horizontal,
                children: mapBikeController.availableStatus
                    .map((statusLabel) => Obx(() {
                          return BuildButtonStatus(
                              label: statusLabel,
                              setFilters: mapBikeController.setStatus,
                              isSelected: mapBikeController.selectedStatusList
                                  .contains(statusLabel),
                              screenWidth: screenWidth);
                        }))
                    .toList())
          ]))
    ]);
  }
}

class BuildButtonFilter extends StatelessWidget {
  const BuildButtonFilter(
      {Key? key,
      required this.screenWidth,
      required this.label,
      required this.setFilters,
      required this.isSelected})
      : super(key: key);

  final double screenWidth;
  final String label;
  final Function setFilters;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
        label: Text(label,
            style: TextStyle(
                color: isSelected ? GlobalStyles.blue : GlobalStyles.greyLine,
                fontSize: 12.0,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        shape: StadiumBorder(
            side: BorderSide(
                color: isSelected
                    ? GlobalStyles.blue
                    : GlobalStyles.backgroundLightGrey,
                width: 1.5)),
        onSelected: (bool value) => setFilters(value, label),
        checkmarkColor: GlobalStyles.blue,
        showCheckmark: true,
        selected: isSelected,
        selectedColor: Colors.white,
        pressElevation: 0.0);
  }
}

class BuildButtonStatus extends StatelessWidget {
  const BuildButtonStatus(
      {Key? key,
      required this.screenWidth,
      required this.label,
      required this.setFilters,
      required this.isSelected})
      : super(key: key);

  final double screenWidth;
  final String label;
  final Function setFilters;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
        label: Text(label,
            style: TextStyle(
                color: isSelected
                    ? colorStatusTypology[label]
                    : GlobalStyles.greyLine,
                fontSize: 12.0,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        shape: StadiumBorder(
            side: BorderSide(
                color: isSelected
                    ? colorStatusTypology[label]
                    : GlobalStyles.backgroundLightGrey,
                width: 1.5)),
        onSelected: (bool value) => setFilters(value, label),
        checkmarkColor: colorStatusTypology[label],
        showCheckmark: true,
        selected: isSelected,
        selectedColor: Colors.white,
        pressElevation: 0.0);
  }
}
