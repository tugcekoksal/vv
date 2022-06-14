// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/models/carte/bike_list_model.dart';
import 'package:velyvelo/models/carte/bike_map_model.dart';

// Models
import 'package:velyvelo/models/map/map_model.dart';

Future<List<BikeMapModel>> fetchBikeMapService(
    String urlServer,
    List<String> filtersList,
    List<String> statusList,
    String searchText,
    String userToken) async {
  var request = http.Request("GET", Uri.parse("$urlServer/api/map/bike/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  request.body = json.encode(
      {"groups": filtersList, "status": statusList, "search": searchText});
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();

  String body = await response.stream.bytesToString();

  if (response.statusCode >= 400) {
    String message = jsonDecode(body)["message"] ?? "Pas de message du serveur";
    throw (message);
  }
  return bikeMapModelFromJson(body);
}

Future<BikePopupModel> fetchBikePopupService(
    String urlServer, int id, String userToken) async {
  var request =
      http.Request("GET", Uri.parse("$urlServer/api/map/bike/popup/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  request.body = json.encode({"id": id});
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();

  String body = await response.stream.bytesToString();

  if (response.statusCode >= 400) {
    String message = jsonDecode(body)["message"] ?? "Pas de message du serveur";
    throw (message);
  }
  return BikePopupModel.fromJson(jsonDecode(body));
}

Future<List<BikeListModel>> fetchBikeListService(
    String urlServer,
    List<String> filtersList,
    List<String> statusList,
    String searchText,
    bool hasGps,
    String userToken) async {
  var request = http.Request("GET", Uri.parse("$urlServer/api/list/bike/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };

  request.body = json.encode({
    "groups": filtersList,
    "status": statusList,
    "search": searchText,
    "has_gps": hasGps
  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();

  String body = await response.stream.bytesToString();
  if (response.statusCode >= 400) {
    String message = jsonDecode(body)["message"] ?? "Pas de message du serveur";
    throw (message);
  }
  return bikeListModelFromJson(body);
}
