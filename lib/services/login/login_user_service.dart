import 'package:http/http.dart' as http;
import 'package:velyvelo/models/login/login_model.dart';

Future loginUserService(String urlServer, String login, String password) async {
  var request = await http.post(Uri.parse("$urlServer/api-token-auth/"),
      body: {"username": login, "password": password});
  if (request.statusCode == 200) {
    var token = request.body;
    return loginModelFromJson(token).token;
  } else if (request.statusCode == 400) {
    var error = request.body;
    print("error");
    print(error);
  } else {
    throw Exception("Login ${request.body}");
  }
}
