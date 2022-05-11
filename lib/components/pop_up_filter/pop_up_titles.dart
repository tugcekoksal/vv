// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/config/colorStatusTypology.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

class PopUpTitle extends StatelessWidget {
  final String text;

  const PopUpTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text,
          style: TextStyle(
              color: GlobalStyles.greyText,
              fontSize: 22.0,
              fontWeight: FontWeight.w600)),
    );
  }
}

class PopUpSubTitle extends StatelessWidget {
  final String text;

  const PopUpSubTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 5, 5),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
