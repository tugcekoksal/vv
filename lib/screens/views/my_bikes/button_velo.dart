// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Components
import 'package:velyvelo/controllers/map_provider/map_view_provider.dart';

class ButtonTypeMapElem extends ConsumerWidget {
  final WhichMapView whichView;

  const ButtonTypeMapElem({Key? key, required this.whichView})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MapViewProvider view = ref.watch(mapViewProvider);

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: view.isActiveMapView(whichView)
                ? global_styles.blue
                : global_styles.backgroundDarkGrey),
        child: IconButton(
            onPressed: () => view.toggleMapView(whichView),
            icon: Icon(
              whichView == WhichMapView.hubView
                  ? Icons.other_houses
                  : Icons.pedal_bike,
              color: view.isActiveMapView(whichView)
                  ? Colors.white
                  : global_styles.greyText,
            )));
  }
}
