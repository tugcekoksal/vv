import 'dart:convert';

import 'package:velyvelo/models/incident/incident_card_model.dart';

IncidentsModel incidentsModelFromJson(String str) =>
    IncidentsModel.fromJson(json.decode(str));

String incidentsModelToJson(IncidentsModel data) => json.encode(data.toJson());

class IncidentsModel {
  IncidentsModel({
    required this.nbIncidents,
    required this.incidents,
  });

  final NbIncidents nbIncidents;
  final List<IncidentCardModel> incidents;

  factory IncidentsModel.empty() =>
      IncidentsModel(nbIncidents: NbIncidents.empty(), incidents: []);

  factory IncidentsModel.fromJson(Map<String, dynamic> json) => IncidentsModel(
        nbIncidents: NbIncidents.fromJson(json["nb_incidents"]),
        incidents: List<IncidentCardModel>.from(
            json["incidents"].map((x) => IncidentCardModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nb_incidents": nbIncidents.toJson(),
        "incidents":
            List<Map<String, dynamic>>.from(incidents.map((x) => x.toJson())),
      };
}

class Incident {
  Incident(
      {required this.incidentTypeReparation,
      required this.incidentStatus,
      required this.incidentPk,
      required this.veloGroup,
      required this.veloName,
      required this.clientName,
      required this.dateCreation,
      required this.interventionTime,
      required this.reparationNumber});

  final String incidentTypeReparation;
  final String incidentStatus;
  final String incidentPk;
  final String veloGroup;
  final String veloName;
  final String clientName;
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
      clientName: json["client_name"] ?? "Pas de nom de client",
      dateCreation: json["date_creation"] ?? "Pas de date de création",
      interventionTime: json["intervention_time"] ?? 0,
      reparationNumber: json["numero_reparation"] ?? "Pas de nom");

  Map<String, dynamic> toJson() => {
        "incident_type_reparation": incidentTypeReparation,
        "incident_status": incidentStatus,
        "incident_pk": incidentPk,
        "velo_group": veloGroup,
        "velo_name": veloName,
        "client_name": clientName,
        "date_creation": dateCreation,
        "intervention_time": interventionTime,
        "numero_reparation": reparationNumber
      };
}

class NbIncidents {
  NbIncidents({
    required this.nouvelle,
    required this.enCours,
    required this.termine,
  });

  final int nouvelle;
  final int enCours;
  final int termine;

  factory NbIncidents.empty() =>
      NbIncidents(nouvelle: 0, enCours: 0, termine: 0);

  factory NbIncidents.fromJson(Map<String, dynamic> json) => NbIncidents(
        nouvelle: json["Nouvelle"] ?? 0,
        enCours: json["Planifié"] ?? 0,
        termine: json["Terminé"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Nouvelle": nouvelle,
        "Planifié": enCours,
        "Terminé": termine,
      };
}
