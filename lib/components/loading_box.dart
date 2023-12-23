// Vendor
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

class LoadingBox extends StatelessWidget {
  const LoadingBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: global_styles.backgroundLightGreyLoading,
        highlightColor: Colors.white,
        period: const Duration(milliseconds: 2000),
        child: child);
  }
}
