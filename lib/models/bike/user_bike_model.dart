// To parse this JSON data, do
//
//     final userBikeModel = userBikeModelFromJson(jsonString);

import 'dart:convert';

import 'package:velyvelo/models/incident/incidents_model.dart';

UserBikeModel userBikeModelFromJson(String str) =>
    UserBikeModel.fromJson(json.decode(str));

String userBikeModelToJson(UserBikeModel data) => json.encode(data.toJson());

class UserBikeModel {
  UserBikeModel(
      {this.clientName = "",
      this.numeroCadran = "",
      this.kilometrage = 0.0,
      this.dateCreation = "",
      this.pictureUrl = "",
      this.bikeName = "",
      this.groupeName = "",
      this.isStolen = false,
      this.veloPk = 0,
      this.inProgressRepairs = const [],
      this.otherRepairs = const []});

  String clientName;
  String bikeName;
  String numeroCadran;
  double kilometrage;
  String dateCreation;
  String pictureUrl;
  String groupeName;
  bool isStolen;
  int veloPk;
  List<Incident> inProgressRepairs;
  List<Incident> otherRepairs;

  factory UserBikeModel.fromJson(Map<String, dynamic> json) => UserBikeModel(
        clientName: json["client_name"] ?? "Pas de nom de client",
        numeroCadran: json["numero_cadran"] ?? "Pas de numéro cadran",
        kilometrage: json["kilometrage"] ?? 0,
        dateCreation: json["date_creation"] ?? "Pas de date",
        pictureUrl: json["picture_url"] ?? "Pas de photo",
        bikeName: json["nom"] ?? "Pas de nom de vélo",
        groupeName: json["groupe_name"] ?? "Pas de nom de groupe",
        isStolen: json["vole"] ?? false,
        veloPk: json["pk"] ?? false,
        inProgressRepairs: List<Incident>.from(
            json["in_progress_repairs"].map((x) => Incident.fromJson(x))),
        otherRepairs: List<Incident>.from(
            json["other_repairs"].map((x) => Incident.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "client_name": clientName,
        "numero_cadran": numeroCadran,
        "kilometrage": kilometrage,
        "date_creation": dateCreation,
        "picture_url": pictureUrl,
        "nom": bikeName,
        "groupe_name": groupeName,
        "vole": isStolen,
        "pk": veloPk
      };
}
