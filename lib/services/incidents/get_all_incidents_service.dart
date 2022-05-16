// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/models/incident/refresh_incident_model.dart';

Future fetchAllIncidentsService(String urlServer,
    RefreshIncidentModel incidentsToFetch, String userToken) async {
  var request = http.Request("GET", Uri.parse("$urlServer/api/infoIncident/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  request.body = json.encode(incidentsToFetch.toJson());

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  String responseStr = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    IncidentsModel incidents = incidentsModelFromJson(responseStr);
    return incidents;
  } else if (response.statusCode == 403) {
    print(response.statusCode);
    throw Exception("No data currently available");
  } else {
    print(response.statusCode);
    throw Exception("No data currently available s");
  }
}

Future fetchReparationByPkService(
    String urlServer, String incidentPk, String userToken) async {
  var response = await http.post(Uri.parse("$urlServer/api/reparationInfos/"),
      body: {"incident_pk": incidentPk},
      headers: {"Authorization": "Token $userToken"});

  if (response.statusCode == 200) {
    // print(response.body);
    return utf8.decode(response.bodyBytes);
  } else {
    throw Exception("Error getting reparation infos with pk");
  }
}
