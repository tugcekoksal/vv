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

class ButtonSearch extends StatelessWidget {
  const ButtonSearch({Key? key}) : super(key: key);

  // Method to instantiate the filter's page
  Future<void> showSearch() async {
    // return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return BuildPopUpSearch();
    //     }).then((value) {
    //   // Check if filters have changed and fire the fetch of bikes if true
    //   mapBikesController.bikesBySearch();
    //   // If fetchAllBikes() gets no bikes then show it to the user
    // });
  }

  @override
  Widget build(BuildContext context) {
    return TopButton(
        actionFunction: () => {}, isLoading: false, iconButton: Icons.search);
  }
}
