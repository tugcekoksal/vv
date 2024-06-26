import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velyvelo/models/login/login_model.dart';

Future<String> loginUserService(
    String urlServer, String login, String password) async {
  // If user did not filled the required fields
  if (login.isEmpty) {
    throw "Le champ identifiant ne peut être vide";
  }
  if (password.isEmpty) {
    throw "Le champ mot de passe ne peut être vide";
  }

  // If the fields are filled, ask for a token to the server
  http.Response response = await http.post(
      Uri.parse("$urlServer/api-token-auth/"),
      body: {"username": login, "password": password});

  String body = utf8.decode(response.bodyBytes);

  // If server response error
  if (response.statusCode >= 400) {
    throw "Les informations fournies sont invalides";
  }
  // If server valid response
  return loginModelFromJson(body).token;
}

Future<String> deleteUserService(
    String urlServer, String token, String password) async {
  if (token.isEmpty) {
    throw "Erreur, veuillez vous connecter à nouveau";
  }
  if (password.isEmpty) {
    throw "Erreur, vous devez renseigner votre mot de passe";
  }

  // If the fields are filled, ask to delete the account
  http.Response response = await http.post(
      Uri.parse("$urlServer/delete_account/"),
      headers: {"Authorization": 'Token $token'},
      body: {"password": password});

  // String body = utf8.decode(response.bodyBytes);

  // If server response error
  if (response.statusCode >= 400) {
    throw "Nous n'avons pas pu vérifier votre identité";
  }
  // If server valid response
  return "Compte supprimé";
}
