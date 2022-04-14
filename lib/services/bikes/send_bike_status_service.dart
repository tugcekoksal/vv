// Vendor
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/incident/incident_update_model.dart';

Future sendCurrentDetailBikeStatusService(String urlServer, int incidentPk,
    bool isFunctional, String statusName, String userToken) async {
  var request =
      http.Request("POST", Uri.parse("$urlServer/api/updateIncident/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  request.body = incidentUpdateModelToJson(IncidentUpdateModel(
      incidentPk: incidentPk,
      isFunctional: isFunctional,
      statusName: statusName));
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  await response.stream.bytesToString();

  if (response.statusCode == 200) {
    print("$statusName has been sent");
    print(response);
  } else if (response.statusCode == 400) {
    var error = request.body;
    print("error");
    print(error);
  } else {
    throw Exception("status current detail ${request.body}");
  }
}
