// Vendor
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/map/map_filter_model.dart';

Future<MapFilterModel> fetchMapfiltersService(
    String urlServer, String userToken) async {
  var response = await http.get(Uri.parse("$urlServer/api/filterMap/"),
      headers: {"Authorization": 'Token $userToken'});
  print(urlServer);
  if (response.statusCode == 200) {
    var data = response.body;
    return mapFilterModelFromJson(data);
  } else {
    throw Exception();
  }
}
