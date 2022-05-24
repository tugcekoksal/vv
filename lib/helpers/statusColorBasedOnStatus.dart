import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

Color colorBasedOnIncidentStatus(String incidentStatus) {
  Color colorStatus;
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

    case "Pas de status d'incident":
      {
        colorStatus = global_styles.greyLogin;
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
