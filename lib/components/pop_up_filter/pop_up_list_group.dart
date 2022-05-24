// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

class BuildButtonGroup extends StatelessWidget {
  const BuildButtonGroup(
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
        padding: const EdgeInsets.all(0),
        labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        label: Text(label,
            style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : global_styles.backgroundDarkGrey,
                fontSize: 12.0,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        shape: const StadiumBorder(
            side: BorderSide(
                color: global_styles.backgroundDarkGrey, width: 1.5)),
        onSelected: (bool value) => setFilters(value, label),
        checkmarkColor: global_styles.blue,
        showCheckmark: false,
        selected: isSelected,
        selectedColor: global_styles.backgroundDarkGrey,
        pressElevation: 0.0);
  }
}

class PopUpGroupList extends StatelessWidget {
  final MapBikesController mapBikesController;
  final ScrollController scrollController = ScrollController();

  PopUpGroupList({Key? key, required this.mapBikesController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scrollbar(
      controller: scrollController,
      isAlwaysShown: true,
      child: ListView(
        controller: scrollController,
        children: [
          Obx(() {
            return Wrap(
                spacing: 4.0,
                direction: Axis.horizontal,
                children: mapBikesController.availableFiltersList.isEmpty
                    ? [const Text("Aucun filtre disponible")]
                    : mapBikesController.availableFiltersList
                        .map((filterLabel) => Obx(() {
                              return BuildButtonGroup(
                                  label: filterLabel,
                                  setFilters: mapBikesController.setFilters,
                                  isSelected: mapBikesController
                                      .selectedFiltersList
                                      .contains(filterLabel));
                            }))
                        .toList());
          })
        ],
      ),
    ));
  }
}
