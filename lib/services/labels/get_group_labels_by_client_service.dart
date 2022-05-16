// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/models/incident/incident_detail_model.dart';

// Models
import 'package:velyvelo/models/labels/group_labels_model.dart';
import 'package:velyvelo/services/bikes/send_bike_status_service.dart';

Future<List<IdAndName>> fetchGroupLabelsByClientService(
    String urlServer, int clientPk, String userToken) async {
  var response = await http.post(
      Uri.parse("$urlServer/api/groupeListByClient/"),
      body: {"client_pk": json.encode(clientPk)},
      headers: {"Authorization": 'Token $userToken'});

  if (response.statusCode >= 400) {
    String message =
        json.decode(response.body)["message"] ?? "Pas de message du serveur";
    throw Exception(message);
  }
  return jsonListToIdAndNameList(json.decode(response.body));
}
