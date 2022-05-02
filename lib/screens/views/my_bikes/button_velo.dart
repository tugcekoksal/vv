// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Components
import 'package:velyvelo/components/BuildPopUpFilters.dart';
import 'package:velyvelo/components/BuildPopUpSearch.dart';
import 'package:velyvelo/controllers/hub_controller.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';
import 'package:velyvelo/screens/views/scanView.dart';
import 'package:velyvelo/services/http_service.dart';

class ButtonTypeMapElem extends StatelessWidget {
  final HubController hubController;
  final bool isHub;

  const ButtonTypeMapElem(
      {Key? key, required this.hubController, required this.isHub})
      : super(key: key);

  changeView() {
    hubController.hubView.value = isHub;
    print(hubController.hubView.value);
  }

  bool activated() {
    return isHub == hubController.hubView.value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: activated()
                  ? GlobalStyles.blue
                  : GlobalStyles.backgroundDarkGrey),
          child: IconButton(
              onPressed: () => changeView(),
              icon: Icon(
                isHub ? Icons.other_houses : Icons.pedal_bike,
                color: activated() ? Colors.white : GlobalStyles.greyText,
              )));
    });
  }
}
