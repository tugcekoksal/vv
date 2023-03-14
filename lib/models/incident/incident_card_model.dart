List<IncidentCardModel> incidentCardsListFromJson(List json) {
  List<IncidentCardModel> likesList =
      json.map((e) => IncidentCardModel.fromJson(e)).toList();
  return likesList;
}

class IncidentCardModel {
  IncidentCardModel(
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

  factory IncidentCardModel.fromJson(Map<String, dynamic> json) =>
      IncidentCardModel(
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
