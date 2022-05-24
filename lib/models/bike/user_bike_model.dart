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
      {required this.clientName,
      required this.numeroCadran,
      required this.kilometrage,
      required this.dateCreation,
      required this.pictureUrl,
      required this.bikeName,
      required this.groupeName,
      required this.isStolen,
      required this.veloPk,
      required this.inProgressRepairs,
      required this.otherRepairs});

  final String clientName;
  final String bikeName;
  final String numeroCadran;
  final double kilometrage;
  final String dateCreation;
  final String? pictureUrl;
  final String? groupeName;
  final bool isStolen;
  final int veloPk;
  final List<Incident> inProgressRepairs;
  final List<Incident> otherRepairs;

  factory UserBikeModel.fromJson(Map<String, dynamic> json) => UserBikeModel(
        clientName: json["client_name"] ?? "Pas de nom de client",
        numeroCadran: json["numero_cadran"] ?? "Pas de numéro cadran",
        kilometrage: json["kilometrage"] ?? 0,
        dateCreation: json["date_creation"] ?? "Pas de date",
        pictureUrl: json["picture_url"],
        bikeName: json["nom"] ?? "Pas de nom de vélo",
        groupeName: json["groupe_name"],
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
