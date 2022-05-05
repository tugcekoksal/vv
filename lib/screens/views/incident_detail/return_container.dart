// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/bike_controller.dart';

const LONGTEXT = 14;

class ReturnStyled extends StatelessWidget {
  final String text;

  const ReturnStyled({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Stack(
            clipBehavior: Clip.none,
            alignment: text.length > LONGTEXT
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.center,
            children: [
              Positioned(
                  left: 0,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: GlobalStyles.greyText,
                      ))),
              Container(
                  padding: text.length > LONGTEXT
                      ? EdgeInsets.fromLTRB(60, 0, 0, 0)
                      : EdgeInsets.all(0),
                  child: Flexible(
                    child: Text(text,
                        style: TextStyle(
                            color: GlobalStyles.greyText,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w700)),
                  )),
            ]));
  }
}

class ReturnContainer extends StatelessWidget {
  final String text;

  const ReturnContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => Navigator.pop(context)), child: ReturnStyled(text: text));
  }
}

class ReturnContainerToScan extends StatelessWidget {
  final String text;
  final BikeController bikeController;

  const ReturnContainerToScan(
      {Key? key, required this.bikeController, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() =>
            {bikeController.isViewingScanPage(false), Navigator.pop(context)}),
        child: ReturnStyled(text: text));
  }
}
