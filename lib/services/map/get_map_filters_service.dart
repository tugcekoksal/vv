// Vendor
import 'dart:convert';

import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/map/map_filter_model.dart';

Future<MapFilterModel> fetchMapfiltersService(
    String urlServer, String userToken) async {
  var response = await http.get(Uri.parse("$urlServer/api/filterMap/"),
      headers: {"Authorization": 'Token $userToken'});
  String body = utf8.decode(response.bodyBytes);
  if (response.statusCode == 200) {
    return mapFilterModelFromJson(body);
  } else {
    throw Exception();
  }
}
