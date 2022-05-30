// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> setBikeRobbedService(
    String urlServer, int id, bool robbed, String userToken) async {
  await Future.delayed(const Duration(seconds: 1));
  String robbedString = robbed ? "True" : "False";

  http.Response response = await http.post(Uri.parse("$urlServer/api/robbed/"),
      body: {"velo_pk": json.encode(id), "robbed": robbedString},
      headers: {"Authorization": "Token $userToken"});

  // http.StreamedResponse response = await request.send();
  String body = utf8.decode(response.bodyBytes);

  String message = jsonDecode(body)["message"] ?? "Pas de message du serveur";

  if (response.statusCode >= 400) {
    throw Exception(message);
  }
  return message;
}
