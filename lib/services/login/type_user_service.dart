// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velyvelo/models/login/user_type_model.dart';

Future<UserType> fetchTypeUserService(
    String urlServer, String userToken) async {
  var request = await http.get(Uri.parse("$urlServer/api/getTypeUser/v2/"),
      headers: {"Authorization": "Token $userToken"});

  if (request.statusCode >= 400) {
    throw Exception(request.body);
  }
  return clientTypeFromJson(json.decode(request.body));
}
