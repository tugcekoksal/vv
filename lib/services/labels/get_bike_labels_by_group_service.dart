// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/labels/bike_labels_model.dart';

Future fetchBikeLabelsByGroupService(
    String urlServer, int groupPk, String userToken) async {
  var headers = {
    'Authorization': 'Token $userToken',
    'Content-Type': 'application/json'
  };

  var request =
      http.Request('POST', Uri.parse('$urlServer/api/veloListByGroupe/'));

  request.body = json.encode({"groupe_pk": groupPk});

  request.headers.addAll(headers);

  print(request.body);
  print(request.headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var bikeLabels = await response.stream.bytesToString();
    return bikeLabelsListModelFromJson(bikeLabels);
  } else {
    print(response.reasonPhrase);
  }
}
