// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

// Views
import 'package:velyvelo/screens/views/bike_profile/bike_profile_view.dart';

class BikeDetailScan extends StatefulWidget {
  const BikeDetailScan({
    Key? key,
  }) : super(key: key);

  @override
  _BikeDetailScanState createState() => _BikeDetailScanState();
}

class _BikeDetailScanState extends State<BikeDetailScan> {
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
