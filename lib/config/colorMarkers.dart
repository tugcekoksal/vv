import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

Color getColorBasedOnMarkersStatus(String markersStatus) {
  var colorStatus;
  switch (markersStatus) {
    case "Utilisé":
      {
        colorStatus = GlobalStyles.purple;
      }
      break;

    case "Rangé":
      {
        colorStatus = GlobalStyles.green;
      }
      break;

    case "Volé":
      {
        colorStatus = GlobalStyles.orange;
      }
      break;

    default:
      {
        colorStatus = GlobalStyles.backgroundDarkGrey;
      }
      break;
  }

  return colorStatus;
}
