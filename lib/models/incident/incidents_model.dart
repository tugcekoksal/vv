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
  Incident(
      {required this.incidentTypeReparation,
      required this.incidentStatus,
      required this.incidentPk,
      required this.veloGroup,
      required this.veloName,
      required this.dateCreation,
      required this.interventionTime,
      required this.reparationNumber});

  final String incidentTypeReparation;
  final String incidentStatus;
  final String incidentPk;
  final String veloGroup;
  final String veloName;
  final String dateCreation;
  final int interventionTime;
  final String reparationNumber;

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
      incidentTypeReparation:
          json["incident_type_reparation"] ?? "Pas de type de réparation",
      incidentStatus: json["incident_status"] ?? "Pas de status d'incident",
      incidentPk: json["incident_pk"] ?? "-1",
      veloGroup: json["velo_group"] ?? "Pas de groupe",
      veloName: json["velo_name"] ?? "Pas de nom de vélo",
      dateCreation: json["date_creation"] ?? "Pas de date de création",
      interventionTime: json["intervention_time"] ?? 0,
      reparationNumber: json["numero_reparation"] ?? "Pas de nom");

  Map<String, dynamic> toJson() => {
        "incident_type_reparation": incidentTypeReparation,
        "incident_status": incidentStatus,
        "velo_group": veloGroup,
        "velo_name": veloName,
        "date_creation": dateCreation,
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
        nouvelle: json["Nouvelle"],
        enCours: json["En cours"],
        termine: json["Termine"],
      );

  Map<String, dynamic> toJson() => {
        "Nouvelle": nouvelle,
        "En cours": enCours,
        "Termine": termine,
      };
}
