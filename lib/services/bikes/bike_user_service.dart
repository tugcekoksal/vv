// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/bike/user_bike_model.dart';
import 'package:velyvelo/models/bike/bike_id_to_send_model.dart';

Future fetchUserBikeService(
    String urlServer, int veloPk, String userToken) async {
  var request = http.Request("POST", Uri.parse("$urlServer/api/profilVelo/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  UserBikeIdToSend bikeIdTosend = new UserBikeIdToSend(veloPk: veloPk);

  request.body = json.encode(bikeIdTosend.toJson());
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  String responseStr = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    print("User bike on air");
    var userBike = responseStr;
    return userBikeModelFromJson(userBike);
  } else if (response.statusCode == 400) {
    var error = request.body;
    print("error");
    print(error);
  } else {
    throw Exception("UserBike ${request.body}");
  }
}
