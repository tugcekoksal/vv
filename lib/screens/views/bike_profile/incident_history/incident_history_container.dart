// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';

// Components
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_history_button.dart';
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_historic_card.dart';

class IncidentHistoryContainer extends StatelessWidget {
  final BikeController bikeController;

  const IncidentHistoryContainer({Key? key, required this.bikeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        children: [
          // Button toggling the list display
          IncidentHistoryButton(bikeController: bikeController),
          // List display
          AnimatedSize(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: Obx(() {
                return Container(
                    height: bikeController.isBikeIncidentsOpen.value ? null : 0,
                    child: Column(
                      children: [
                        bikeController.userBike.value.otherRepairs.length == 0
                            ? Text("Il y aura des éléments ici")
                            : Column(
                                children: [
                                  SizedBox(height: 20),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: bikeController
                                          .userBike.value.otherRepairs.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () => null,
                                            child: IncidentHistoricCard(
                                              data: bikeController.userBike
                                                  .value.otherRepairs[index],
                                              isHistorique: true,
                                            ));
                                      }),
                                ],
                              )
                      ],
                    ));
              }))
        ],
      ),
    );
  }
}
