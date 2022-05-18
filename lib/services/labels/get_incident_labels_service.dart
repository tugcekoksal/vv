// Vendor
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velyvelo/models/incident/incident_detail_model.dart';

Future<List<IdAndName>> fetchIncidentLabelsService(
    String urlServer, String userToken) async {
  var response = await http.get(Uri.parse("$urlServer/api/typeIncidentList/"),
      headers: {"Authorization": 'Token $userToken'});

  String body = utf8.decode(response.bodyBytes);
  if (response.statusCode >= 400) {
    String message =
        json.decode(body)["message"] ?? "Pas de message du serveur";
    throw Exception(message);
  }
  return jsonListToIdAndNameList(json.decode(body));
}
