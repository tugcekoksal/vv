// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Access Token
const accesToken =
    "sk.eyJ1IjoibHVjYXNncmFmZW4iLCJhIjoiY2wwNnA2a3NnMDRndzNpbHYyNTV0NGd1ZCJ9.nfFc_JlfaGgq1Kajg6agoQ";

class InfoContainer extends StatelessWidget {
  final bool isVisible;
  final Color colorBackground;
  final Widget child;

  const InfoContainer(
      {super.key,
      required this.isVisible,
      required this.colorBackground,
      required this.child});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: const Duration(milliseconds: 750),
      child: Container(
          width: screenWidth * 0.9,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
  final Color color;

  const InfoNotFound(
      {super.key,
      required this.color,
      required this.text,
      required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      isVisible: isVisible,
      colorBackground: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500)),
          const Icon(Icons.info_outline, color: Colors.white, size: 25.0)
        ],
      ),
    );
  }
}

class InfoLoading extends StatelessWidget {
  final String text;
  final bool isVisible;

  const InfoLoading({super.key, required this.text, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      isVisible: isVisible,
      colorBackground: global_styles.backgroundDarkGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400)),
          SizedBox(
            height: 20,
            width: 20,
            child: isVisible
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
