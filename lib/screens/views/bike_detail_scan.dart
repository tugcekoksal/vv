// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 65.0,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Vélo Scanné',
            style: TextStyle(
                color: GlobalStyles.greyTitle,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 15.0),
            child: SvgPicture.asset("assets/logo.svg",
                height: 15.0, width: 15.0, fit: BoxFit.scaleDown),
          ),
        ),
        body: MyBikeView(
          isFromScan: true,
        ));
  }
}
