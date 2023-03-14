// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/incident/client_card_model.dart';
import 'package:velyvelo/models/incident/group_card_model.dart';
import 'package:velyvelo/screens/views/incidents/components/group_card.dart';

// Models
import 'package:velyvelo/services/http_service.dart';

Future<List<GroupCardModel>> fetchGroupCardsService(
    int idClient, String urlServer, String userToken) async {
  final log = logger(HttpService);

  var request =
      http.Request("GET", Uri.parse("$urlServer/api/list/group/card/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  request.headers.addAll(headers);
  request.body = json.encode({"id": idClient});
  http.StreamedResponse streamedResponse = await request.send();
  http.Response response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    return groupCardsListFromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    log.e(response.statusCode);
    throw Exception("Error fetching client cards list data");
  }
}
