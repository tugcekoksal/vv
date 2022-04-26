// To parse this JSON data, do
//
//     final userBikeModel = userBikeModelFromJson(jsonString);

import 'dart:convert';

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
        clientName: json["client_name"] == null ? null : json["client_name"],
        numeroCadran:
            json["numero_cadran"] == null ? null : json["numero_cadran"],
        kilometrage: json["kilometrage"] == null ? null : json["kilometrage"],
        dateCreation:
            json["date_creation"] == null ? null : json["date_creation"],
        pictureUrl: json["picture_url"] == null ? null : json["picture_url"],
        bikeName: json["nom"] == null ? null : json["nom"],
        groupeName: json["groupe_name"] == null ? null : json["groupe_name"],
        isStolen: json["vole"] == null ? false : json["vole"],
        veloPk: json["pk"] == null ? false : json["pk"],
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

Incident incidentFromJson(String str) => Incident.fromJson(json.decode(str));

String incidentToJson(Incident data) => json.encode(data.toJson());

class Incident {
  Incident({
    required this.incidentTypeReparation,
    required this.incidentStatus,
    required this.veloGroup,
    required this.veloName,
    required this.dateCreation,
    required this.incidentPk,
    required this.interventionTime,
  });

  String incidentTypeReparation;
  String incidentStatus;
  String veloGroup;
  String veloName;
  String dateCreation;
  String incidentPk;
  int interventionTime;

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
        incidentTypeReparation: json["incident_type_reparation"],
        incidentStatus: json["incident_status"],
        veloGroup:
            json["velo_group"] != null ? "Aucun groupe" : json["velo_group"],
        veloName: json["velo_name"],
        dateCreation: json["date_creation"],
        incidentPk: json["incident_pk"],
        interventionTime: json["intervention_time"],
      );

  Map<String, dynamic> toJson() => {
        "incident_type_reparation": incidentTypeReparation,
        "incident_status": incidentStatus,
        "velo_group": veloGroup,
        "velo_name": veloName,
        "date_creation": dateCreation,
        "incident_pk": incidentPk,
        "intervention_time": interventionTime,
      };
}
