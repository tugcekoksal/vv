// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Components
import 'package:velyvelo/components/BuildPopUpFilters.dart';
import 'package:velyvelo/components/BuildPopUpSearch.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';
import 'package:velyvelo/screens/views/scanView.dart';

class ButtonFilter extends StatelessWidget {
  final MapBikesController mapBikesController;

  const ButtonFilter({Key? key, required this.mapBikesController})
      : super(key: key);

  Future<void> displayFilters(context) async {
    mapBikesController.isFiltersChanged(false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BuildPopUpFilters();
        }).then((value) {
      // Check if filters have changed and fire the fetch of bikes if true
      mapBikesController.onChangeFilters();
      // If fetchAllBikes() gets no bikes then show it to the user
    });
  }

  @override
  Widget build(BuildContext context) {
    return TopButton(
        actionFunction: () => displayFilters(context),
        isLoading: false,
        iconButton: Icons.filter_list_outlined);
  }
}
