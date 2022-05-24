// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;
import 'package:velyvelo/controllers/bike_controller.dart';

const longText = 14;

class ReturnStyled extends StatelessWidget {
  final String text;

  const ReturnStyled({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Stack(
            clipBehavior: Clip.none,
            alignment: text.length > longText
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.center,
            children: [
              Positioned(
                  left: 0,
                  child: Container(
                      padding: const EdgeInsets.all(5),
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
                      child: const Icon(
                        Icons.close,
                        size: 25,
                        color: global_styles.greyText,
                      ))),
              Container(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Text(text,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: global_styles.greyText,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w700))),
                    ],
                  )),
            ]));
  }
}

class ReturnContainer extends StatelessWidget {
  final String text;
  final Function? optionalFunction;
  const ReturnContainer({Key? key, required this.text, this.optionalFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => {
              if (optionalFunction != null) {optionalFunction!()},
              Navigator.pop(context)
            }),
        child: ReturnStyled(text: text));
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

class ReturnBar extends StatelessWidget {
  final String text;
  final Function? optionalFunction;

  const ReturnBar({Key? key, required this.text, this.optionalFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0))),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ReturnContainer(text: text, optionalFunction: optionalFunction),
    );
  }
}

class ReturnBarScan extends StatelessWidget {
  final String text;
  final BikeController bikeController;

  const ReturnBarScan(
      {Key? key, required this.text, required this.bikeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0))),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ReturnContainerToScan(text: text, bikeController: bikeController),
    );
  }
}
