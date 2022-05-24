import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

Color getColorBasedOnMarkersStatus(String markersStatus) {
  var colorStatus;
  switch (markersStatus) {
    case "Utilisé":
      {
        colorStatus = global_styles.purple;
      }
      break;

    case "Rangé":
      {
        colorStatus = global_styles.green;
      }
      break;

    case "Volé":
      {
        colorStatus = global_styles.orange;
      }
      break;

    default:
      {
        colorStatus = global_styles.backgroundDarkGrey;
      }
      break;
  }

  return colorStatus;
}
