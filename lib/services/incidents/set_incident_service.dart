// Vendor
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/incident/incident_to_send_model.dart';

Future<String> setIncidentService(
    String urlServer, IncidentToSendModel incident, String userToken) async {
  var headers = {
    'Authorization': 'Token $userToken',
    'Content-Type': 'application/json'
  };
  http.MultipartRequest request = http.MultipartRequest(
      'POST', Uri.parse('$urlServer/api/declareIncident/'));
  request
    ..fields["velo_pk"] = incident.veloPk
    ..fields["type"] = incident.type
    ..fields["commentary"] = incident.commentary
    ..fields["is_self_attributed"] = jsonEncode(incident.isSelfAttributed);

  // Check if at least on photo has been taken
  if (incident.files.isNotEmpty) {
    // Loop threw all incident photos and add it to the request
    for (var i = 0; i < incident.files.length; i++) {
      request.files.add(
          await http.MultipartFile.fromPath('files', incident.files[i].path));
    }
  } else {
    // Otherwise, add an empty list
    request.fields.addAll({"files": json.encode([])});
  }
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  String body = await response.stream.bytesToString();
  String message = jsonDecode(body)["message"] ?? "Pas de message du serveur";

  if (response.statusCode >= 400) {
    throw Exception(message);
  }
  return message;
}
