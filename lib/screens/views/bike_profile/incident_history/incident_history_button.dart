// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/bike_provider/bike_profile_provider.dart';

class IncidentHistoryButton extends ConsumerWidget {
  const IncidentHistoryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BikeProfileProvider bikeProfile = ref.watch(bikeProfileProvider);
    return GestureDetector(
        onTap: () => ref.read(bikeProfileProvider).toggleIsBikeIncidentsOpen(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Historique des incidents",
                style: TextStyle(
                    color: global_styles.purple,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600)),
            Icon(
                bikeProfile.isBikeIncidentsOpen
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: global_styles.greyDropDown,
                size: 30)
          ],
        ));
  }
}
