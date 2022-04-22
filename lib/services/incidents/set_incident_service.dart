// Vendor
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/incident/incident_to_send_model.dart';

Future setIncidentService(
    String urlServer, IncidentToSendModel incident, String userToken) async {
  var headers = {
    'Authorization': 'Token $userToken',
    'Content-Type': 'application/json'
  };
  var request = http.MultipartRequest(
      'POST', Uri.parse('$urlServer/api/declareIncident/'));
  request
    ..fields["velo_pk"] = incident.veloPk
    ..fields["type"] = incident.type
    ..fields["commentary"] = incident.commentary
    ..fields["is_self_attributed"] = jsonEncode(incident.isSelfAttributed);

  // Check if at least on photo has been taken
  if (incident.files.length != 0) {
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

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return 'Vos incidents ont été ajouté avec succès.';
  } else {
    print(response);
  }
}
