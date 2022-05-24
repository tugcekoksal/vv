// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

class BuildFormsDivider extends StatelessWidget {
  const BuildFormsDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: global_styles.greyText,
      height: 2,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
    );
  }
}
