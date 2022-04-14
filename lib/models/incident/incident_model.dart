// To parse this JSON data, do
//
//     final incidentModel = incidentModelFromJson(jsonString);

import 'dart:convert';

IncidentModel incidentModelFromJson(String str) => IncidentModel.fromJson(json.decode(str));


class IncidentModel {
    IncidentModel({
        required this.groupe,
        required this.velo,
        required this.batteries,
        required this.typeIncident,
        required this.commentaire,
        required this.photos,
    });

    final String? groupe;
    final String? velo;
    final String? batteries;
    final String? typeIncident;
    final String? commentaire;
    final List<String>? photos;

    factory IncidentModel.fromJson(Map<String, dynamic> json) => IncidentModel(
        groupe: json["groupe"] == null ? null : json["groupe"],
        velo: json["velo"] == null ? null : json["velo"],
        batteries: json["batteries"] == null ? null : json["batteries"],
        typeIncident: json["type_incident"] == null ? null : json["type_incident"],
        commentaire: json["commentaire"] == null ? null : json["commentaire"],
        photos: json["photos"] == null ? null : List<String>.from(json["photos"].map((x) => x)),
    );
}
