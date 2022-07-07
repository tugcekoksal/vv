// Global Styles like colors
import 'package:flutter/material.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Get the color based on its status
Color colorStatusTypology(String statut) {
  switch (statut) {
    case "Rangé":
      return global_styles.green;
    case "Utilisé":
      return global_styles.electricalBlue;
    case "Volé":
      return global_styles.orange;
    case "Pas de gps":
      return global_styles.greyAddPhotos;
  }
  return global_styles.backgroundDarkGrey;
}
