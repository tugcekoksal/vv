// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/hubs/hub_map.dart';
import 'package:velyvelo/services/http_service.dart';

Future<List<HubModel>> fetchHubsService(
    String urlServer, String userToken) async {
  final log = logger(HttpService);
  var request = http.Request("GET", Uri.parse("$urlServer/api/mapHub/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  request.body = json.encode([]);
  request.headers.addAll(headers);
  http.StreamedResponse streamResponse = await request.send();
  http.Response response = await http.Response.fromStream(streamResponse);
  // String message =
  //     json.decode(response.body)["message"] ?? "No message from server";
  log.w(response.statusCode);
  if (response.statusCode >= 400) {
    throw Exception("message");
  }
  List<HubModel> listHubs = [];
  // return listHubs;
  return hubsModelFromJson(response.body);
}

Future fetchOneHubService(String urlServer, int pk, String userToken) async {
  var request = http.Request("POST", Uri.parse("$urlServer/api/mapHub/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

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
