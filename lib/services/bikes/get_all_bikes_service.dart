// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/map/filter_list_model.dart';
import 'package:velyvelo/models/map/map_model.dart';

Future fetchAllBikesService(String urlServer, List filtersList, List statusList,
    String userToken) async {
  var request = http.Request("GET", Uri.parse("$urlServer/api/map/"));
  var headers = {
    "Authorization": 'Token $userToken',
    "Content-Type": "application/json"
  };
  FilterListModel filterList = FilterListModel(
      filters: Filters(
          groupes: filtersList.map((filter) => filter.toString()).toList(),
          statusUsing: statusList.map((status) => status.toString()).toList()));
  request.body = json.encode(filterList.toJson());
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  String responseStr = await response.stream.bytesToString();
  if (response.statusCode == 200) {
    return mapModelFromJson(responseStr);
  } else if (response.statusCode == 403) {
    print(response.statusCode);
  } else {
    throw Exception(response.statusCode);
  }
}
