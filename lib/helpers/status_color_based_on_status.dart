import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

Color colorBasedOnIncidentStatus(String incidentStatus,
    {bool isTechnicien = false}) {
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

    case "Clôturé":
      {
        colorStatus = global_styles.green;
      }
      break;

    case "Pas de status d'incident":
      {
        colorStatus = global_styles.greyLogin;
      }
      break;

    case "Planifié":
      {
        if (isTechnicien) {
          colorStatus = global_styles.blue;
        } else {
          colorStatus = global_styles.yellow;
        }
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
