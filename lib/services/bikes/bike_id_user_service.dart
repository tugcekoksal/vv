// Vendor
import 'dart:convert';

import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/bike/user_bike_id_model.dart';

Future fetchBikeIDUserService(String urlServer, String userToken) async {
  var response = await http.get(Uri.parse("$urlServer/api/myVeloId/"),
      headers: {"Authorization": "Token $userToken"});

  String body = utf8.decode(response.bodyBytes);
  if (response.statusCode == 200) {
    print("User bikeID on air");
    return userBikeIDModelFromJson(body);
  } else if (response.statusCode == 400) {
    var error = body;
    print("error");
    print(error);
  } else {
    throw Exception("UserBikeID ${body}");
  }
}
