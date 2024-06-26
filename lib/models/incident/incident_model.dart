// To parse this JSON data, do
//
//     final incidentModel = incidentModelFromJson(jsonString);

import 'dart:convert';

IncidentModel incidentModelFromJson(String str) =>
    IncidentModel.fromJson(json.decode(str));

class IncidentModel {
  IncidentModel({
    required this.groupe,
    required this.velo,
    required this.typeIncident,
    required this.commentaire,
    required this.photos,
  });

  final String? groupe;
  final String? velo;
  final String? typeIncident;
  final String? commentaire;
  final List<String>? photos;

  factory IncidentModel.fromJson(Map<String, dynamic> json) => IncidentModel(
        groupe: json["groupe"],
        velo: json["velo"],
        typeIncident: json["type_incident"],
        commentaire: json["commentaire"],
        photos: json["photos"] == null
            ? null
            : List<String>.from(json["photos"].map((x) => x)),
      );
}
