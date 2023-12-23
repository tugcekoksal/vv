// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

class FormsDivider extends StatelessWidget {
  const FormsDivider({
    super.key,
  });

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
