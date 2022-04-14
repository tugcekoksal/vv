// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/labels/group_labels_model.dart';

Future<List<GroupLabelsListModel>> fetchGroupLabelsByClientService(
    String urlServer, int clientPk, String userToken) async {
  var response = await http.post(
      Uri.parse("$urlServer/api/groupeListByClient/"),
      body: {"client_pk": json.encode(clientPk)},
      headers: {"Authorization": 'Token $userToken'});
  if (response.statusCode == 200) {
    var groupLabels = response.body;
    return groupLabelsListModelFromJson(groupLabels);
  } else if (response.statusCode == 401) {
    print(response.body);
    throw Exception();
  } else {
    throw Exception();
  }
}
