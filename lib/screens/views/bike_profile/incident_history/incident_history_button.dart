// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';

class IncidentHistoryButton extends StatelessWidget {
  final BikeController bikeController;

  const IncidentHistoryButton({Key? key, required this.bikeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => bikeController.toggleIsBikeIncidentsOpen(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Historique des incidents",
                style: TextStyle(
                    color: global_styles.purple,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600)),
            Obx(() {
              return Icon(
                  bikeController.isBikeIncidentsOpen.value
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: global_styles.greyDropDown,
                  size: 30);
            })
          ],
        ));
  }
}
