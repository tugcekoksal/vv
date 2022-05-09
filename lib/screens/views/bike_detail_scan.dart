// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Views
import 'package:velyvelo/screens/views/bike_profile/bike_profile_view.dart';

class BikeDetailScan extends StatefulWidget {
  BikeDetailScan({
    Key? key,
  }) : super(key: key);

  @override
  _BikeDetailScanState createState() => _BikeDetailScanState();
}

class _BikeDetailScanState extends State<BikeDetailScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalStyles.backgroundLightGrey,
        body: MyBikeView(
          isFromScan: true,
        ));
  }
}
