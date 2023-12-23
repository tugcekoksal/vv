// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Views
import 'package:velyvelo/screens/views/bike_profile/bike_profile_view.dart';

class BikeDetailScan extends StatelessWidget {
  const BikeDetailScan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: global_styles.backgroundLightGrey,
        body: MyBikeView(
          isFromScan: true,
        ));
  }
}
