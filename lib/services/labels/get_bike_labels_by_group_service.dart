// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/models/json_usefull.dart';

Future<Map<String, List<IdAndName>>> fetchBikeLabelsByGroupService(
    String urlServer, int groupPk, int clientPk, String userToken) async {
  var headers = {
    'Authorization': 'Token $userToken',
    'Content-Type': 'application/json'
  };

  var request =
      http.Request('POST', Uri.parse('$urlServer/api/veloListByGroupe/'));

  request.body = json.encode({"groupe_pk": groupPk, "client_pk": clientPk});

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  String body = await response.stream.bytesToString();
  if (response.statusCode >= 400) {
    String message =
        json.decode(body)["message"] ?? "Pas de message du serveur";
    throw Exception(message);
  }
  return {
    "velos": jsonListToIdAndNameList(json.decode(body)[0]["velos"]),
    "batteries": jsonListToIdAndNameList(json.decode(body)[0]["batteries"])
  };
}
