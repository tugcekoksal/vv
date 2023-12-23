// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controllers
import 'package:velyvelo/controllers/bike_provider/bike_profile_provider.dart';

// Components
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_history_button.dart';
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_historic_card.dart';

class IncidentHistoryContainer extends ConsumerWidget {
  const IncidentHistoryContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BikeProfileProvider bikeProfile = ref.watch(bikeProfileProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        children: [
          // Button toggling the list display
          const IncidentHistoryButton(),
          // List display
          AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: SizedBox(
                  height: bikeProfile.isBikeIncidentsOpen ? null : 0,
                  child: Column(
                    children: [
                      bikeProfile.userBike.otherRepairs.isEmpty
                          ? const Text("Il y aura des éléments ici")
                          : Column(
                              children: [
                                const SizedBox(height: 20),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: bikeProfile
                                        .userBike.otherRepairs.length,
                                    itemBuilder: (context, index) {
                                      return IncidentHistoricCard(
                                        data: bikeProfile
                                            .userBike.otherRepairs[index],
                                        isHistorique: true,
                                      );
                                    }),
                              ],
                            )
                    ],
                  )))
        ],
      ),
    );
  }
}
