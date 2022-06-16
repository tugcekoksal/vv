// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/carte/hub_list_model.dart';
import 'package:velyvelo/models/carte/hub_map_model.dart';
import 'package:velyvelo/services/http_service.dart';

Future<List<HubMapModel>> fetchHubMapService(
    String urlServer, String search, String userToken) async {
  final log = logger(HttpService);
  var request = http.Request("GET", Uri.parse("$urlServer/api/map/hub/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  request.body = json.encode({"search": search});
  request.headers.addAll(headers);
  http.StreamedResponse streamResponse = await request.send();
  http.Response response = await http.Response.fromStream(streamResponse);

  if (response.statusCode >= 400) {
    String message =
        json.decode(response.body)["message"] ?? "No message from server";
    log.e(message);
    throw Exception(message);
  }
  return hubMapModelFromJson(response.body);
}

Future<List<HubListModel>> fetchHubListService(
    String urlServer, String search, String userToken) async {
  final log = logger(HttpService);
  var request = http.Request("GET", Uri.parse("$urlServer/api/list/hub/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  request.body = json.encode({"search": search});
  request.headers.addAll(headers);
  http.StreamedResponse streamResponse = await request.send();
  http.Response response = await http.Response.fromStream(streamResponse);

  if (response.statusCode >= 400) {
    String message =
        json.decode(response.body)["message"] ?? "No message from server";
    log.e(message);
    throw Exception(message);
  }
  return hubListModelFromJson(response.body);
}

Future<HubListModel> fetchHubPopupService(
    String urlServer, int id, String userToken) async {
  var request = http.Request("GET", Uri.parse("$urlServer/api/map/hub/popup/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  request.body = json.encode({"id": id});
  request.headers.addAll(headers);

  http.StreamedResponse streamedResponse = await request.send();
  http.Response response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode >= 400) {
    String message =
        json.decode(response.body)["message"] ?? "No message from server";
    throw Exception(message);
  }
  return HubListModel.fromJson(json.decode(response.body));
}
