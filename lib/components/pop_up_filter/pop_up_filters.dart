// Vendor
import 'package:flutter/material.dart';

// Components
import 'package:velyvelo/components/pop_up_filter/pop_up_list_filters.dart';
import 'package:velyvelo/components/pop_up_filter/pop_up_list_group.dart';
import 'package:velyvelo/components/pop_up_filter/pop_up_list_status.dart';
import 'package:velyvelo/components/pop_up_filter/pop_up_titles.dart';

class PopUpFilters extends StatelessWidget {
  const PopUpFilters({super.key});

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
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.0)),
                color: Colors.white),
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const PopUpTitle(text: "Filtrer mes vélos"),
              const PopUpSubTitle(text: "Filtres appliqués"),
              PopUpListFilters(),
              const PopUpSubTitle(text: "Status"),
              const PopUpStatusList(),
              const PopUpSubTitle(text: "Groupes"),
              PopUpGroupList()
            ]),
          )
        ]);
  }
}
