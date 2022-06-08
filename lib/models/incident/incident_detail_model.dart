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
    required this.velo,
    required this.typeIncident,
    required this.commentaire,
    required this.photos,
    required this.isFunctional,
    required this.actualStatus,
    required this.status,
  });

  final String groupe;
  final String velo;
  final String typeIncident;
  final String commentaire;
  final List<String> photos;
  final bool isFunctional;
  final String actualStatus;
  final List<String> status;

  factory IncidentDetailModel.fromJson(Map<String, dynamic> json) =>
      IncidentDetailModel(
        groupe: json["groupe"] ?? "Pas de nom de groupe",
        velo: json["velo"] ?? "Pas de nom de vélo",
        typeIncident: json["type_incident"] ?? "Pas de type d'incident",
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

  TextEditingController commentary;

  ReparationModel(
      {required this.statusBike,
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
      required this.commentary});

  factory ReparationModel.fromJson(Map<String, dynamic> jsonData,
      int? incidentPk, List<File> listPhotoFile) {
    return ReparationModel(
        statusBike: getStringOrNull(jsonData["status_bike"]),
        isBikeFunctional: getBoolOrNull(jsonData["is_bike_functional"]),
        incidentPk: getIntOrNull(incidentPk),
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
        commentary: TextEditingController(
            text: getStringOrNull(jsonData["commentary"])));
  }
}
