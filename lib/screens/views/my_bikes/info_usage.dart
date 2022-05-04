// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

// Own modules
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';
import 'package:velyvelo/screens/views/my_bikes/bikes_map.dart';
import 'package:velyvelo/screens/views/my_bikes/bikes_list.dart';

// Access Token
const accesToken =
    "sk.eyJ1IjoibHVjYXNncmFmZW4iLCJhIjoiY2wwNnA2a3NnMDRndzNpbHYyNTV0NGd1ZCJ9.nfFc_JlfaGgq1Kajg6agoQ";

class InfoContainer extends StatelessWidget {
  final bool isVisible;
  final Color colorBackground;
  final Widget child;

  const InfoContainer(
      {Key? key,
      required this.isVisible,
      required this.colorBackground,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: Duration(milliseconds: 750),
      child: Container(
          width: screenWidth * 0.9,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(12.0)),
          child: child),
    );
  }
}

class InfoNotFound extends StatelessWidget {
  final String text;
  final bool isVisible;

  const InfoNotFound({Key? key, required this.text, required this.isVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      isVisible: isVisible,
      colorBackground: GlobalStyles.orange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500)),
          Icon(Icons.info_outline, color: Colors.white, size: 25.0)
        ],
      ),
    );
  }
}

class InfoLoading extends StatelessWidget {
  final String text;
  final bool isVisible;

  const InfoLoading({Key? key, required this.text, required this.isVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      isVisible: isVisible,
      colorBackground: GlobalStyles.backgroundDarkGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400)),
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        ],
      ),
    );
  }
}
