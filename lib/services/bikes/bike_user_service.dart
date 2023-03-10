// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/bike/user_bike_model.dart';
import 'package:velyvelo/models/bike/bike_id_to_send_model.dart';

Future<UserBikeModel> fetchUserBikeService(
    String urlServer, int? veloPk, String? nomVelo, String userToken) async {
  var request = http.Request("POST", Uri.parse("$urlServer/api/profilVelo/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  if (nomVelo != null) {
    request.body = json.encode({"nom_velo": nomVelo});
  }
  if (veloPk != null) {
    request.body = json.encode({"velo_pk": veloPk});
  }
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  String body = await response.stream.bytesToString();
  String message = jsonDecode(body)["message"] ?? "Pas de message du serveur";

  if (response.statusCode >= 400) {
    throw Exception(message);
  }
  return userBikeModelFromJson(body);
}
