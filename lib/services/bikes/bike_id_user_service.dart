// Vendor
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velyvelo/helpers/logger.dart';

// Models
import 'package:velyvelo/models/bike/user_bike_id_model.dart';
import 'package:velyvelo/services/http_service.dart';

Future fetchBikeIDUserService(String urlServer, String userToken) async {
  var response = await http.get(Uri.parse("$urlServer/api/myVeloId/"),
      headers: {"Authorization": "Token $userToken"});
  final log = logger(HttpService);
  String body = utf8.decode(response.bodyBytes);
  if (response.statusCode == 200) {
    return userBikeIDModelFromJson(body);
  } else if (response.statusCode == 400) {
    var error = body;
    log.e(error);
  } else {
    throw Exception("UserBikeID " + body);
  }
}
