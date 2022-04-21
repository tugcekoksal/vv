// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class ReturnContainer extends StatelessWidget {
  final String text;

  const ReturnContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => Navigator.pop(context)),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.arrow_back_ios,
                color: GlobalStyles.greyText,
                size: 20.0,
              ),
              Text(text,
                  style: TextStyle(
                      color: GlobalStyles.greyText,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w700)),
            ])));
  }
}
