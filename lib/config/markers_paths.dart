import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Get the color of the pin based on its status
const Map markersPaths = {
  "Volé": "assets/pins/orange_pin.png",
  "Rangé": "assets/pins/green_pin.png",
  "Utilisé": "assets/pins/blue_pin.png"
};

const Map markersColor = {
  "Volé": global_styles.orange,
  "Rangé": global_styles.green,
  "Utilisé": global_styles.blue,
  "": global_styles.backgroundDarkGrey
};
