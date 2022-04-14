// Vendor
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/bike/user_bike_id_model.dart';

Future fetchBikeIDUserService(String urlServer, String userToken) async {
    var request =
      await http.get(
        Uri.parse("$urlServer/api/myVeloId/"),
        headers: {
          "Authorization": "Token $userToken"
        }
      );
      
    if (request.statusCode == 200) {
      print("User bikeID on air");
      var userBikeID = request.body;
      return userBikeIDModelFromJson(userBikeID);
    } else if (request.statusCode == 400) {
      var error = request.body;
      print("error");
      print(error);
    } else {
      throw Exception("UserBikeID ${request.body}");
    }
  }