// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/incident/incident_detail_model.dart';

Future<IncidentDetailModel> fetchIncidentByIdService(
    String urlServer, int id, String userToken) async {
  var response = await http.post(Uri.parse("$urlServer/api/incident/"),
      headers: {"Authorization": 'Token $userToken'},
      body: {"incident_pk": json.encode(id)});

  String body = utf8.decode(response.bodyBytes);
  String message = jsonDecode(body)["message"] ?? "Pas de message du serveur";

  if (response.statusCode >= 400) {
    throw (message);
  }
  return incidentDetailModelFromJson(body);
}
