// To parse this JSON data, do
//
//     final incidentsModel = incidentsModelFromJson(jsonString);

import 'dart:convert';

IncidentsModel incidentsModelFromJson(String str) =>
    IncidentsModel.fromJson(json.decode(str));

String incidentsModelToJson(IncidentsModel data) => json.encode(data.toJson());

class IncidentsModel {
  IncidentsModel({
    required this.nbIncidents,
    required this.incidents,
  });

  final NbIncidents nbIncidents;
  final List<Incident> incidents;

  factory IncidentsModel.fromJson(Map<String, dynamic> json) => IncidentsModel(
        nbIncidents: NbIncidents.fromJson(json["nb_incidents"]),
        incidents: List<Incident>.from(
            json["incidents"].map((x) => Incident.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nb_incidents": nbIncidents.toJson(),
        "incidents": List<dynamic>.from(incidents.map((x) => x.toJson())),
      };
}

class Incident {
  Incident({
    required this.incidentTypeReparation,
    required this.incidentStatus,
    required this.incidentPk,
    required this.veloGroup,
    required this.veloName,
    required this.dateCreation,
    required this.interventionTime,
  });

  final String? incidentTypeReparation;
  final String? incidentStatus;
  final String? incidentPk;
  final String veloGroup;
  final String veloName;
  final String? dateCreation;
  final int interventionTime;

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
        incidentTypeReparation: json["incident_type_reparation"] == null
            ? null
            : json["incident_type_reparation"],
        incidentStatus:
            json["incident_status"] == null ? null : json["incident_status"],
        incidentPk: json["incident_pk"] == null ? null : json["incident_pk"],
        veloGroup:
            json["velo_group"] == null ? "Pas de groupe" : json["velo_group"],
        veloName: json["velo_name"] == null ? "Erreur" : json["velo_name"],
        dateCreation:
            json["date_creation"] == null ? null : json["date_creation"],
        interventionTime:
            json["intervention_time"] == null ? 0 : json["intervention_time"],
      );

  Map<String, dynamic> toJson() => {
        "incident_type_reparation":
            incidentTypeReparation == null ? null : incidentTypeReparation,
        "incident_status": incidentStatus == null ? null : incidentStatus,
        "velo_group": veloGroup,
        "velo_name": veloName,
        "date_creation": dateCreation == null ? null : dateCreation,
        "intervention_time": interventionTime
      };
}

class NbIncidents {
  NbIncidents({
    required this.nouvelle,
    required this.enCours,
    required this.termine,
  });

  final int? nouvelle;
  final int? enCours;
  final int? termine;

  factory NbIncidents.fromJson(Map<String, dynamic> json) => NbIncidents(
        nouvelle: json["Nouvelle"] == null ? null : json["Nouvelle"],
        enCours: json["En cours"] == null ? null : json["En cours"],
        termine: json["Termine"] == null ? null : json["Termine"],
      );

  Map<String, dynamic> toJson() => {
        "Nouvelle": nouvelle == null ? null : nouvelle,
        "En cours": enCours == null ? null : enCours,
        "Termine": termine == null ? null : termine,
      };
}
