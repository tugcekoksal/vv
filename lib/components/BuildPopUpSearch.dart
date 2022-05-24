// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

class BuildPopUpSearchVelo extends StatelessWidget {
  BuildPopUpSearchVelo({Key? key}) : super(key: key);

  final MapBikesController mapBikeController = Get.put(MapBikesController());
  final textInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        children: [
          Container(
            width: screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: Colors.white),
            child: TextField(
              controller: textInputController,
              decoration: InputDecoration(
                  labelText: mapBikeController.searchText.value),
              onChanged: (value) =>
                  {mapBikeController.searchText.value = value},
            ),
          )
        ]);
  }
}
