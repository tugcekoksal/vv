// Vendor
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/bike_controller.dart';

// Components
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_historic_card.dart';

// Service Url
import 'package:flutter/cupertino.dart';

class IncidentInProgress extends StatelessWidget {
  final BikeController bikeController;

  const IncidentInProgress({Key? key, required this.bikeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Les incidents en cours",
                  style: TextStyle(
                      color: GlobalStyles.purple,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(height: 10.0),
          bikeController.userBike.value.inProgressRepairs.length == 0
              ? Center(
                  child: Text("Aucun incident en cours"),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                      itemCount: bikeController
                          .userBike.value.inProgressRepairs.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => {},
                          child: IncidentHistoricCard(
                            data: bikeController
                                .userBike.value.inProgressRepairs[index],
                            isHistorique: false,
                          ),
                        );
                      }),
                )
        ]));
  }
}