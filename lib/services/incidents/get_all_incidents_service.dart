// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/helpers/logger.dart';

// Models
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/models/incident/refresh_incident_model.dart';
import 'package:velyvelo/services/http_service.dart';

Future<IncidentsModel> fetchAllIncidentsService(
    String urlServer,
    RefreshIncidentModel incidentsToFetch,
    String searchText,
    String userToken) async {
  final log = logger(HttpService);

  var request = http.Request("GET", Uri.parse("$urlServer/api/listIncidents/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  request.body = json.encode(incidentsToFetch.toJson(searchText));

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  String responseStr = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    IncidentsModel incidents = incidentsModelFromJson(responseStr);
    return incidents;
  } else if (response.statusCode == 403) {
    log.e(response.statusCode);
    throw Exception("No data currently available");
  } else {
    log.e(response.statusCode);
    throw Exception("No data currently available s");
  }
}

Future fetchIncidentService(
    String urlServer, String incidentPk, String userToken) async {
  var response = await http.post(Uri.parse("$urlServer/api/reparation/"),
      body: {"incident_pk": incidentPk},
      headers: {"Authorization": "Token $userToken"});

  if (response.statusCode == 200) {
    return utf8.decode(response.bodyBytes);
  } else {
    throw Exception("Error getting reparation infos with pk");
  }
}

Future fetchIncidentFiltersService(String urlServer, String userToken) async {
  var response = await http.get(Uri.parse("$urlServer/api/incidentFilters/"),
      headers: {"Authorization": "Token $userToken"});

  if (response.statusCode >= 400) {
    throw Exception("Error server fetch filters");
  }
  return json.decode(response.body);
}
