// To parse this JSON data, do
//
//     final incidentDetailModel = incidentDetailModelFromJson(jsonString);

import 'dart:convert';

// Helpers
import 'package:velyvelo/helpers/utf8_convert.dart';

// IncidentDetailModel incidentDetailModelFromJson(String str) => IncidentDetailModel.fromJson(json.decode(utf8convert(str)));

// class IncidentDetailModel {
//     IncidentDetailModel({
//         required this.groupe,
//         required this.velo,
//         required this.batteries,
//         required this.typeIncident,
//         required this.commentaire,
//         required this.photos,
//     });

//     final String? groupe;
//     final String? velo;
//     final String? batteries;
//     final String? typeIncident;
//     final String? commentaire;
//     final List<String>? photos;

//     factory IncidentDetailModel.fromJson(Map<String, dynamic> json) => IncidentDetailModel(
//         groupe: json["groupe"] == null ? null : json["groupe"],
//         velo: json["velo"] == null ? null : json["velo"],
//         batteries: json["batteries"] == null ? null : json["batteries"],
//         typeIncident: json["type_incident"] == null ? null : json["type_incident"],
//         commentaire: json["commentaire"],
//         photos: json["photos"] == null ? null : List<String>.from(json["photos"].map((x) => x)),
//     );
// }

// To parse this JSON data, do
//
//     final incidentDetailModel = incidentDetailModelFromJson(jsonString);

IncidentDetailModel incidentDetailModelFromJson(String str) =>
    IncidentDetailModel.fromJson(json.decode(utf8convert(str)));

class IncidentDetailModel {
  IncidentDetailModel({
    required this.groupe,
    required this.velo,
    required this.batteries,
    required this.typeIncident,
    required this.commentaire,
    required this.photos,
    required this.isFunctional,
    required this.actualStatus,
    required this.status,
  });

  final String? groupe;
  final String? velo;
  final String? batteries;
  final String? typeIncident;
  final String? commentaire;
  final List<String>? photos;
  final bool? isFunctional;
  final String? actualStatus;
  final List<String>? status;

  factory IncidentDetailModel.fromJson(Map<String, dynamic> json) =>
      IncidentDetailModel(
        groupe: json["groupe"] == null ? null : json["groupe"],
        velo: json["velo"] == null ? null : json["velo"],
        batteries: json["batteries"] == null ? null : json["batteries"],
        typeIncident:
            json["type_incident"] == null ? null : json["type_incident"],
        commentaire: json["commentaire"] == null ? null : json["commentaire"],
        photos: json["photos"] == null
            ? null
            : List<String>.from(json["photos"].map((x) => x)),
        isFunctional:
            json["is_functional"] == null ? null : json["is_functional"],
        actualStatus:
            json["actual_status"] == null ? null : json["actual_status"],
        status: json["status"] == null
            ? null
            : List<String>.from(json["status"].map((x) => x)),
      );
}
