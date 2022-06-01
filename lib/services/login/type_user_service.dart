// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchTypeUserService(String urlServer, String userToken) async {
  var request = await http.get(Uri.parse("$urlServer/api/getTypeUser/"),
      headers: {"Authorization": "Token $userToken"});

  if (request.statusCode >= 400) {
    throw Exception(request.body);
  }
  return json.decode(request.body);
}
