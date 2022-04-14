// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class BuildFormsDivider extends StatelessWidget {
  const BuildFormsDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalStyles.greyText,
      height: 2,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
    );
  }
}