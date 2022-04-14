// Vendor
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class BuildLoadingBox extends StatelessWidget {
  const BuildLoadingBox({
    Key? key,
    required this.child
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: GlobalStyles.backgroundLightGreyLoading,
      highlightColor: Colors.white,
      period: Duration(milliseconds: 2000),
      child: child
    );
  }
}