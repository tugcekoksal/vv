// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

Future setBikeRobbedService(
    String urlServer, int id, bool robbed, String userToken) async {
  await Future.delayed(Duration(seconds: 1));
  String robbedString = robbed ? "True" : "False";

  var response = await http.post(Uri.parse("$urlServer/api/robbed/"),
      body: {"velo_pk": json.encode(id), "robbed": robbedString},
      headers: {"Authorization": "Token $userToken"});

  if (response.statusCode == 200) {
    print(response.body);
    print("Bike robbed status has been set to: $robbed");
  } else {
    throw Exception("Problem with bike robbed value");
  }
}
