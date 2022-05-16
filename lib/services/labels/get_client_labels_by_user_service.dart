// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/incident/incident_detail_model.dart';

Future<List<IdAndName>> fetchClientLabelsByUserService(
    String urlServer, String userToken) async {
  http.Response response = await http.get(
      Uri.parse("$urlServer/api/clientListByUser/"),
      headers: {"Authorization": 'Token $userToken'});

  // If error from server
  if (response.statusCode >= 400) {
    String message =
        json.decode(response.body)["message"] ?? "No message from server";
    throw Exception(message);
  }
  // The status is OK : we give the data from the server
  return jsonListToIdAndNameList(json.decode(response.body));
}
