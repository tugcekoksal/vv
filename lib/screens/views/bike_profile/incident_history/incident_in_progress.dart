// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/bike_controller.dart';
import 'package:velyvelo/controllers/bike_provider/bike_profile_provider.dart';

// Components
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_historic_card.dart';

// Service Url
import 'package:flutter/cupertino.dart';

class IncidentInProgress extends ConsumerWidget {
  const IncidentInProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BikeProfileProvider bikeProfile = ref.watch(bikeProfileProvider);

    return Column(children: [
      const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10),
          child: Text("Les incidents en cours",
              style: TextStyle(
                  color: global_styles.purple,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ),
      ),
      // SizedBox(height: 10.0),
      bikeProfile.userBike.inProgressRepairs.isEmpty
          ? const Center(
              child: Text("Aucun incident en cours"),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: bikeProfile.userBike.inProgressRepairs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => {},
                      child: IncidentHistoricCard(
                        data: bikeProfile.userBike.inProgressRepairs[index],
                        isHistorique: false,
                      ),
                    );
                  }),
            )
    ]);
  }
}
