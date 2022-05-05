// Vendor
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Components
import 'package:velyvelo/components/BuildIncidentOverview.dart';
import 'package:velyvelo/components/BuildLoadingBox.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/screens/views/incident_detail/incident_detail_view.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';
import 'package:velyvelo/helpers/statusColorBasedOnStatus.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class FadeListView extends StatelessWidget {
  final Widget child;

  const FadeListView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              GlobalStyles.backgroundLightGrey,
              Colors.transparent,
              Colors.transparent,
              GlobalStyles.backgroundLightGrey
            ],
            stops: [
              0.0,
              0.08,
              0.92,
              1.0
            ], // 10% background, 80% transparent, 10% background
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: child);
  }
}
