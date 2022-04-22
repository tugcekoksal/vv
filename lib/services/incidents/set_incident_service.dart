// Vendor
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/incident/incident_to_send_model.dart';

Future setIncidentService(
    String urlServer, IncidentToSendModel incident, String userToken) async {
  // var headers = {'Authorization': 'Token $userToken'};
  // var request = http.MultipartRequest(
  //     'POST', Uri.parse('$urlServer/api/declareIncident/'));
  // request.fields.addAll({
  //   'client_pk': json.encode(incident.clientPk),
  //   'velo_pk': json.encode(incident.veloPk),
  //   'type': incident.type,
  //   'commentary': incident.commentary,
  // });

  // Check if at least on photo has been taken
  // if (incident.files.length != 0) {
  //   // Loop threw all incident photos and add it to the request
  //   for (var i = 0; i < incident.files.length; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('files', incident.files[i].path));
  //   }
  // } else {
  //   // Otherwise, add an empty list
  //   request.fields.addAll({"files": json.encode([])});
  // }

  // request.headers.addAll(headers);

  // http.StreamedResponse response = await request.send();
  // var headers = {
  //   'Authorization': 'Token f78ba9d0399ca31f7cb129348136ec1611ee30ec',
  //   'Content-Type': 'application/json'
  // };
  // var request = http.MultipartRequest(
  //     'POST', Uri.parse('http://54.38.32.109/api/declareIncident/'));
  // request.fields.addAll({
  //   "client_pk": json.encode(incident.clientPk),
  //   "velo_pk": json.encode(incident.veloPk),
  //   "type": "Autre",
  //   "commentary": ""
  // });
  // // Check if at least on photo has been taken
  // if (incident.files.length != 0) {
  //   // Loop threw all incident photos and add it to the request
  //   for (var i = 0; i < incident.files.length; i++) {
  //     request.files.add(
  //         await http.MultipartFile.fromPath('files', incident.files[i].path));
  //   }
  // } else {
  //   // Otherwise, add an empty list
  // }
  // request.headers.addAll(headers);

  // http.StreamedResponse response = await request.send();

  // if (response.statusCode == 200) {
  //   print(await response.stream.bytesToString());
  //   print("couocuoucouc");
  //   return 'Vos incidents ont été ajouté avec succès.';
  // } else {
  //   print(response.reasonPhrase);
  //   print("MAI SNNA");
  // }
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

  print(request);
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
  // var headers = {
  //   'Authorization': 'Token 206e7f9a38ef1e4b64592acfff1229de154bd798',
  //   'Content-Type': 'application/json'
  // };
  // var request = http.MultipartRequest(
  //     'POST', Uri.parse('https://dms.velyvelo.com/api/declareIncident/'));
  // request.fields.addAll({
  //   "client_pk": json.encode(-1),
  //   "velo_pk": json.encode(3033),
  //   "type": "Autre - Laissez un commentaire",
  //   "commentary": "",
  //   "files": json.encode([])
  // });
  // print({
  //   "client_pk": json.encode(-1),
  //   "velo_pk": json.encode(3033),
  //   "type": "Autre - Laissez un commentaire",
  //   "commentary": "",
  //   "files": json.encode([])
  // });
  // request.headers.addAll(headers);

  // http.StreamedResponse response = await request.send();

  // if (response.statusCode == 200) {
  //   print(await response.stream.bytesToString());
  // } else {
  //   print(response.reasonPhrase);
  // }
}
