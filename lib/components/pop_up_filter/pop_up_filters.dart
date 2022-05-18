// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Components
import 'package:velyvelo/components/pop_up_filter/pop_up_list_filters.dart';
import 'package:velyvelo/components/pop_up_filter/pop_up_list_group.dart';
import 'package:velyvelo/components/pop_up_filter/pop_up_list_status.dart';
import 'package:velyvelo/components/pop_up_filter/pop_up_titles.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

class PopUpFilters extends StatelessWidget {
  PopUpFilters({Key? key}) : super(key: key);

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
              PopUpTitle(text: "Filtrer mes vélos"),
              PopUpSubTitle(text: "Filtres appliqués"),
              PopUpListFilters(mapBikesController: mapBikeController),
              PopUpSubTitle(text: "Status"),
              PopUpStatusList(mapBikesController: mapBikeController),
              PopUpSubTitle(text: "Groupes"),
              PopUpGroupList(mapBikesController: mapBikeController)
            ]),
          )
        ]);
  }
}
