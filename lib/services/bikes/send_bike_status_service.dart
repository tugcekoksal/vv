// Vendor
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velyvelo/models/incident/incident_detail_model.dart';

List<int> listIdFromListIdAndName(List<IdAndName> theList) {
  return theList.map((elem) => elem.id).toList();
}

Future sendCurrentDetailBikeStatusService(
    String urlServer, Reparation reparation, String userToken) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('$urlServer/api/updateIncident/'));
  request
    ..fields["incident_pk"] = json.encode(reparation.incidentPk)
    ..fields["is_bike_functional"] =
        reparation.isBikeFunctional ? "True" : "False"
    ..fields["status_bike"] = reparation.statusBike
    ..fields["pieces"] =
        json.encode(reparation.selectedPieces.map((elem) => elem.id).toList())
    ..fields["commentary"] = reparation.commentary.value.text;

  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  request.headers.addAll(headers);

  // Check if at least on photo has been taken
  if (reparation.reparationPhotosList.length != 0) {
    // Loop threw all incident photos and add it to the request
    for (var i = 0; i < reparation.reparationPhotosList.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
          'files', reparation.reparationPhotosList[i].path));
    }
  } else {
    // Otherwise, add an empty list
    request.fields.addAll({"files": json.encode([])});
  }
  http.StreamedResponse response = await request.send();
  await response.stream.bytesToString();

  if (response.statusCode == 200) {
    print(response);
  } else if (response.statusCode == 400) {
    print("error updating reparation informations");
    print(response.reasonPhrase);
  } else {
    print(response.reasonPhrase);
    throw Exception("unexpected error updating reparation informations");
  }
}

Future fetchPieceFromTypeService(String urlServer, int interventionType,
    int reparationType, String userToken) async {
  var body = {
    "reparation_type_id": jsonEncode(reparationType),
    "intervention_type_id": jsonEncode(interventionType)
  };
  var response = await http.post(Uri.parse("$urlServer/api/piecesInfos/"),
      body: body, headers: {"Authorization": "Token $userToken"});
  return response.body;
}
