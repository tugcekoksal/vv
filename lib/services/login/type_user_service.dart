// Vendor
import 'dart:convert';
import 'package:http/http.dart' as http;

Future fetchTypeUserService(String urlServer, String userToken) async {
  var request = await http.get(Uri.parse("$urlServer/api/getTypeUser/"),
      headers: {"Authorization": "Token $userToken"});

  if (request.statusCode == 200) {
    var userType = request.body;
    return json.decode(userType);
  } else if (request.statusCode == 400) {
    var error = request.body;
    print("error");
    print(error);
  } else {
    throw Exception("UserType ${request.body}");
  }
}
