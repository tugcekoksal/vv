// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/incident/incident_card_model.dart';

// Models
import 'package:velyvelo/services/http_service.dart';

Future<List<IncidentCardModel>> fetchIncidentCardsService(
    int idGroup, int idClient, String urlServer, String userToken) async {
  final log = logger(HttpService);

  var request =
      http.Request("GET", Uri.parse("$urlServer/api/list/incident/card/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  request.headers.addAll(headers);
  request.body = json.encode({"id": idGroup, "client_id": idClient});
  http.StreamedResponse streamedResponse = await request.send();
  http.Response response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    return incidentCardsListFromJson(
        json.decode(utf8.decode(response.bodyBytes)));
  } else {
    log.e(response.statusCode);
    throw Exception("Error fetching client cards list data");
  }
}
