// Vendor
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velyvelo/models/incident/incident_detail_model.dart';

// Models
import 'package:velyvelo/models/labels/incident_labels_model.dart';

Future<List<IdAndName>> fetchIncidentLabelsService(
    String urlServer, String userToken) async {
  var response = await http.get(Uri.parse("$urlServer/api/typeIncidentList/"),
      headers: {"Authorization": 'Token $userToken'});

  print(response.body);
  if (response.statusCode >= 400) {
    String message =
        json.decode(response.body)["message"] ?? "Pas de message du serveur";
    throw Exception(message);
  }
  return jsonListToIdAndNameList(json.decode(response.body));
}
