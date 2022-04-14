import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

Color colorBasedOnIncidentStatus(String incidentStatus) {
  var colorStatus;
  switch(incidentStatus) { 
    case "Nouvelle": { 
        colorStatus = GlobalStyles.blue;
    } 
    break; 
    
    case "Terminé": { 
        colorStatus = GlobalStyles.green;
    } 
    break;
        
    default: { 
        colorStatus = GlobalStyles.yellow;
    }
    break; 
  } 

  return colorStatus;
}