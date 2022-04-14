// To parse this JSON data, do
//
//     final incidentUpdateModel = incidentUpdateModelFromJson(jsonString);

import 'dart:convert';

String incidentUpdateModelToJson(IncidentUpdateModel data) =>
    json.encode(data.toJson());

class IncidentUpdateModel {
  IncidentUpdateModel({
    required this.incidentPk,
    this.isFunctional,
    this.statusName,
  });

  final int incidentPk;
  bool? isFunctional;
  String? statusName;

  Map<String, dynamic> toJson() => {
        "incident_pk": incidentPk,
        "is_functional": isFunctional,
        "status_name": statusName,
      };
}
