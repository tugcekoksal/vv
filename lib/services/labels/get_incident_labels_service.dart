// Vendor
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/labels/incident_labels_model.dart';

Future<List<String>> fetchIncidentLabelsService(String urlServer, String userToken) async {
    var response =
        await http.get(
          Uri.parse("$urlServer/api/typeIncidentList/"),
          headers: {
            "Authorization": 'Token $userToken'
          }
        );
    if (response.statusCode == 200) {
      var incidentLabels = response.body;
      return incidentLabelsModelFromJson(incidentLabels);
    } else {
      throw Exception();
    }
  }