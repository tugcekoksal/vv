// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

class PopUpTitle extends StatelessWidget {
  final String text;

  const PopUpTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text,
          style: const TextStyle(
              color: global_styles.greyText,
              fontSize: 22.0,
              fontWeight: FontWeight.w600)),
    );
  }
}

class PopUpSubTitle extends StatelessWidget {
  final String text;

  const PopUpSubTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 5, 5),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
