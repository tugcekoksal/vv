// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/models/hubs/hub_map.dart';

Future fetchHubsService(String urlServer, String userToken) async {
  var request = http.Request("GET", Uri.parse("$urlServer/api/mapHub/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  request.body = json.encode([]);
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  String responseStr = await response.stream.bytesToString();
  if (response.statusCode == 200) {
    print(responseStr);
    return hubsModelFromJson(responseStr);
  } else if (response.statusCode == 403) {
    print(responseStr);
    print(response.statusCode);
    return null;
  } else {
    print(response.statusCode);
    print(responseStr);
    return null;
  }
}

Future fetchOneHubService(String urlServer, int pk, String userToken) async {
  var request = http.Request("POST", Uri.parse("$urlServer/api/mapHub/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  print(pk);
  request.body = json.encode({"pk": pk});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  String responseStr = await response.stream.bytesToString();
  if (response.statusCode == 200) {
    print(responseStr);
    return hubsModelFromJson(responseStr);
  } else if (response.statusCode == 403) {
    print(responseStr);
    print(response.statusCode);
    return null;
  } else {
    print(response.statusCode);
    print(responseStr);
    return null;
  }
}
