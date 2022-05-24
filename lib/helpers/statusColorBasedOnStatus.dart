import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

Color colorBasedOnIncidentStatus(String incidentStatus) {
  var colorStatus;
  switch (incidentStatus) {
    case "Nouvelle":
      {
        colorStatus = global_styles.blue;
      }
      break;

    case "Terminé":
      {
        colorStatus = global_styles.green;
      }
      break;

    default:
      {
        colorStatus = global_styles.yellow;
      }
      break;
  }

  return colorStatus;
}
