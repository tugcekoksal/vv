// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

class BuildButtonSelectedFilter extends StatelessWidget {
  final String text;
  final Function setFilters;

  const BuildButtonSelectedFilter(
      {Key? key, required this.text, required this.setFilters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
        padding: const EdgeInsets.all(0),
        labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        label: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(text,
              style: const TextStyle(
                  color: global_styles.backgroundDarkGrey,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          const Icon(
            Icons.close,
            size: 12,
          )
        ]),
        backgroundColor: Colors.white,
        shape: const StadiumBorder(
            side: BorderSide(
                color: global_styles.backgroundDarkGrey, width: 1.5)),
        onSelected: (bool value) => setFilters(false, text),
        checkmarkColor: global_styles.blue,
        showCheckmark: true,
        selected: false,
        selectedColor: Colors.white,
        pressElevation: 0.0);
  }
}

class PopUpListFilters extends StatelessWidget {
  final MapBikesController mapBikesController;
  final ScrollController scrollController = ScrollController();

  PopUpListFilters({Key? key, required this.mapBikesController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.15),
        child: Row(children: [
          Expanded(
              child: Scrollbar(
            controller: scrollController,
            isAlwaysShown: true,
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              children: [
                Obx(
                  (() => Wrap(
                      spacing: 4.0,
                      direction: Axis.horizontal,
                      children: mapBikesController.selectedFiltersList.isEmpty
                          ? [const Text("Aucuns groupes séléctionnés")]
                          : mapBikesController.availableFiltersList
                              .map((filterLabel) => Obx(() {
                                    if (mapBikesController.selectedFiltersList
                                        .contains(filterLabel)) {
                                      return BuildButtonSelectedFilter(
                                          text: filterLabel,
                                          setFilters:
                                              mapBikesController.setFilters);
                                    }
                                    return const SizedBox(
                                      height: 0,
                                      width: 0,
                                    );
                                  }))
                              .toList())),
                )
              ],
            ),
          ))
        ]));
  }
}
