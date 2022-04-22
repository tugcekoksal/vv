// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

class BuildPopUpSearch extends StatelessWidget {
  BuildPopUpSearch({Key? key}) : super(key: key);

  final MapBikesController mapBikeController = Get.put(MapBikesController());
  final textInputController = TextEditingController();

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
              child: Text("Rechercher par nom",
                  style: TextStyle(
                      color: GlobalStyles.greyText,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 25.0),
            Wrap(spacing: 8.0, direction: Axis.horizontal, children: [
              TextField(
                controller: textInputController,
                decoration: InputDecoration(
                    labelText: mapBikeController.searchText.value),
                onChanged: (value) =>
                    {mapBikeController.searchText.value = value},
              ),
              GestureDetector(
                child: Text("Reset"),
                onTap: () => {
                  mapBikeController.searchText.value = "",
                  mapBikeController.fetchAllBikes()
                },
              )
            ]),
          ]))
    ]);
  }
}
