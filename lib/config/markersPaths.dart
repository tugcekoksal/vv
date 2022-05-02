import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Get the color of the pin based on its status
const Map MarkersPaths = {
  "Volé": "assets/pins/orange_pin.png",
  "Rangé": "assets/pins/green_pin.png",
  "Utilisé": "assets/pins/blue_pin.png"
};

const Map MarkersColor = {
  "Volé": GlobalStyles.orange,
  "Rangé": GlobalStyles.green,
  "Utilisé": GlobalStyles.blue
};
