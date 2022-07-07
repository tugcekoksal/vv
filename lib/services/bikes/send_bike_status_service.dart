// Vendor
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/models/json_usefull.dart';

List<int> listIdFromListIdAndName(List<IdAndName> theList) {
  return theList.map((elem) => elem.id ?? -1).toList();
}

Future<String> sendCurrentDetailBikeStatusService(
    String urlServer, ReparationModel reparation, String userToken) async {
  String isBikeFunctionnal = reparation.isBikeFunctional == null
      ? ""
      : reparation.isBikeFunctional!
          ? "True"
          : "False";
  var request = http.MultipartRequest(
      'POST', Uri.parse('$urlServer/api/updateIncident/'));
  request
    ..fields["incident_pk"] = json.encode(reparation.incidentPk)
    ..fields["is_bike_functional"] = isBikeFunctionnal
    ..fields["status_bike"] = reparation.statusBike ?? ""
    ..fields["pieces"] =
        json.encode(reparation.selectedPieces.map((elem) => elem.id).toList())
    ..fields["commentary_tech"] = reparation.commentaryTech.value.text
    ..fields["commentary_admin"] = reparation.commentaryAdmin.value.text
    ..fields["cause"] = reparation.cause.name ?? ""
    ..fields["intervention_type_id"] = reparation.typeIntervention.id.toString()
    ..fields["reparation_type_id"] = reparation.typeReparation.id.toString();

  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  request.headers.addAll(headers);

  // Add the files fields in payload
  request.fields.addAll({"files": json.encode([])});
  // Add files to the payload
  for (var i = 0; i < reparation.reparationPhotosList.length; i++) {
    request.files.add(await http.MultipartFile.fromPath(
        'files', reparation.reparationPhotosList[i].path));
  }

  // Get stream response and convert to response
  http.StreamedResponse streamResponse = await request.send();
  http.Response response = await http.Response.fromStream(streamResponse);
  String message =
      json.decode(response.body)["message"] ?? "No message from server";

  if (response.statusCode >= 400) {
    throw (message);
  }
  // The status is OK : We give a success phrase from the server
  return message;
}

Future fetchPieceFromTypeService(String urlServer, int interventionType,
    int reparationType, String userToken) async {
  var body = {
    "reparation_type_id": jsonEncode(reparationType),
    "intervention_type_id": jsonEncode(interventionType)
  };
  var response = await http.post(Uri.parse("$urlServer/api/piecesInfos/"),
      body: body, headers: {"Authorization": "Token $userToken"});
  return utf8.decode(response.bodyBytes);
}
