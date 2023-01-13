// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

class FadeListView extends StatelessWidget {
  final Widget child;

  const FadeListView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              global_styles.backgroundLightGrey,
              Colors.transparent,
              Colors.transparent,
              global_styles.backgroundLightGrey
            ],
            stops: [
              0.0,
              0.045,
              0.92,
              1.0
            ], // 10% background, 80% transparent, 10% background
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: child);
  }
}
