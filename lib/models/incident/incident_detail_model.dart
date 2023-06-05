// Vendor
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

// Helpers
import 'package:velyvelo/models/json_usefull.dart';

IncidentDetailModel incidentDetailModelFromJson(String str) =>
    IncidentDetailModel.fromJson(json.decode(str));

// Data used to the incident infos on top of incident detail page (all users can view)
class IncidentDetailModel {
  IncidentDetailModel({
    required this.groupe,
    required this.equipement,
    required this.typeIncident,
    required this.typeEquipement,
    required this.commentaire,
    required this.photos,
    required this.isFunctional,
    required this.actualStatus,
    required this.status,
  });

  final String groupe;
  final IdAndName equipement;
  final String typeIncident;
  final String typeEquipement;
  final String commentaire;
  final List<String> photos;
  final bool isFunctional;
  final String actualStatus;
  final List<String> status;

  factory IncidentDetailModel.fromJson(Map<String, dynamic> json) =>
      IncidentDetailModel(
        groupe: json["groupe"] ?? "Pas de nom de groupe",
        equipement: getIdAndNameOrEmpty(json["equipement"]),
        typeIncident: json["type_incident"] ?? "Pas de type d'incident",
        typeEquipement: json["type_equipement"] ?? "Erreur",
        commentaire: json["commentaire"] ?? "Pas de commentaire",
        photos: json["photos"] == null
            ? []
            : List<String>.from(json["photos"].map((x) => x)),
        isFunctional: json["is_functional"] ?? false,
        actualStatus: json["actual_status"] ?? "Pas de status actuel",
        status: json["status"] == null
            ? []
            : List<String>.from(json["status"].map((x) => x)),
      );
}

List<ReparationModel> jsonToListReparationModel(Map<String, dynamic> listJson) {
  List<ReparationModel> listRep = [];
  for (Map<String, dynamic> json in listJson["queue"]) {
    listRep.add(ReparationModel.fromJson(json, []));
  }
  return listRep;
}

Map<String, dynamic> listReparationModelToListJson(
    List<ReparationModel> listRep) {
  List<Map<String, dynamic>> listJson = [];
  for (ReparationModel repUpdate in listRep) {
    listJson.add(repUpdate.toJson());
    listJson.add(repUpdate.toJson());
  }
  return {"queue": listJson};
}

// Data concerning the reparation under the detail of incidents (thecnician and admin view)
class ReparationModel {
  String? statusBike;
  bool? isBikeFunctional;
  int? incidentPk;
  bool noPieces = false;

  IdAndName cause;
  List<IdAndName> causelist;

  IdAndName typeIntervention;
  List<IdAndName> typeInterventionList;

  IdAndName typeReparation;
  List<IdAndName> typeReparationList;

  IdAndName selectedPieceDropDown;
  List<IdAndName> piecesList;
  List<IdAndName> selectedPieces;

  List<File> reparationPhotosList;

  TextEditingController commentaryTech;
  TextEditingController commentaryAdmin;

  String numeroCadran;
  String typeContrat;

  ReparationModel({
    required this.statusBike,
    required this.isBikeFunctional,
    required this.incidentPk,
    required this.noPieces,
    required this.reparationPhotosList,
    required this.typeIntervention,
    required this.typeInterventionList,
    required this.typeReparation,
    required this.typeReparationList,
    required this.cause,
    required this.causelist,
    required this.piecesList,
    required this.selectedPieces,
    required this.selectedPieceDropDown,
    required this.commentaryTech,
    required this.commentaryAdmin,
    required this.numeroCadran,
    required this.typeContrat,
  });

  factory ReparationModel.fromJson(
      Map<String, dynamic> jsonData, List<File> listPhotoFile) {
    return ReparationModel(
        statusBike: getStringOrNull(jsonData["status_bike"]),
        isBikeFunctional: getBoolOrNull(jsonData["is_bike_functional"]),
        incidentPk: getIntOrNull(jsonData["incident_pk"]),
        reparationPhotosList: listPhotoFile,
        cause: getIdAndNameOrEmpty(jsonData["cause"]),
        causelist: getListIdAndName(jsonData["list_cause"]),
        typeIntervention: getIdAndNameOrEmpty(jsonData["type_intervention"]),
        typeReparation: getIdAndNameOrEmpty(jsonData["type_reparation"]),
        typeInterventionList:
            getListIdAndName(jsonData["list_type_intervention"]),
        typeReparationList: getListIdAndName(jsonData["list_type_reparation"]),
        piecesList: [],
        noPieces: false,
        selectedPieces: getListIdAndName(jsonData["pieces"]),
        selectedPieceDropDown: IdAndName(),
        commentaryTech: TextEditingController(
            text: getStringOrNull(jsonData["commentary_tech"])),
        commentaryAdmin: TextEditingController(
            text: getStringOrNull(jsonData["commentary_admin"])),
        numeroCadran: jsonData["numero_cadran"] ?? "",
        typeContrat: jsonData["type_contrat"] ?? "",
        );
  }

  Map<String, dynamic> toJson() => {
        "status_bike": statusBike,
        "is_bike_functional": isBikeFunctional,
        "incident_pk": incidentPk,
        // list photo file
        "cause": cause.toJson(),
        "list_cause": idAndNameListToJson(causelist),
        "type_intervention": typeIntervention.toJson(),
        "type_reparation": typeReparation.toJson(),
        "list_type_intervention": idAndNameListToJson(typeInterventionList),
        "list_type_reparation": idAndNameListToJson(typeReparationList),
        // list pieces (model ?)
        // no pieces
        "pieces": idAndNameListToJson(selectedPieces),
        // selected piece dropdown
        "commentary_tech": commentaryTech.text,
        "commentary_admin": commentaryAdmin.text,
        "type_contrat": typeContrat,
        "numero_cadran": numeroCadran
      };
}
