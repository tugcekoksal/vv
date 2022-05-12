// To parse this JSON data, do
//
//     final incidentDetailModel = incidentDetailModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

// Helpers
import 'package:flutter/material.dart';
import 'package:velyvelo/helpers/utf8_convert.dart';

IncidentDetailModel incidentDetailModelFromJson(String str) =>
    IncidentDetailModel.fromJson(json.decode(utf8convert(str)));

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

  final String? groupe;
  final String? velo;
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

class IdAndName {
  int id;
  String name;

  IdAndName({required this.id, required this.name});

  factory IdAndName.fromJson(Map<String, dynamic> json) =>
      IdAndName(id: json["id"] ?? 0, name: json["name"] ?? "error");
}

List<IdAndName> jsonListToIdAndNameList(jsonList) {
  List<IdAndName> resList = [];

  if (jsonList != null) {
    for (var obj in jsonList) {
      resList.add(IdAndName.fromJson(obj));
    }
  }
  return resList;
}

class Reparation {
  String statusBike;
  bool isBikeFunctional;
  int incidentPk;
  List<File> reparationPhotosList;
  IdAndName typeIntervention;
  IdAndName typeReparation;
  List<IdAndName> typeInterventionList;
  List<IdAndName> typeReparationList;
  List<IdAndName> piecesList;
  List<IdAndName> selectedPieces;
  IdAndName selectedPieceDropDown;
  TextEditingController commentary;

  Reparation(
      {required this.statusBike,
      required this.isBikeFunctional,
      required this.incidentPk,
      required this.reparationPhotosList,
      required this.typeIntervention,
      required this.typeInterventionList,
      required this.typeReparation,
      required this.typeReparationList,
      required this.piecesList,
      required this.selectedPieces,
      required this.selectedPieceDropDown,
      required this.commentary});

  factory Reparation.fromJson(Map<String, dynamic> json, int incidentPk,
          List<File> listPhotoFile) =>
      Reparation(
          statusBike: json["status_bike"],
          isBikeFunctional: json["is_bike_functional"],
          incidentPk: incidentPk,
          reparationPhotosList: listPhotoFile,
          typeIntervention: IdAndName.fromJson(json["type_intervention"]),
          typeReparation: IdAndName.fromJson(json["type_reparation"]),
          typeInterventionList:
              jsonListToIdAndNameList(json["list_type_intervention"]),
          typeReparationList:
              jsonListToIdAndNameList(json["list_type_reparation"]),
          piecesList: [],
          selectedPieces: jsonListToIdAndNameList(json["pieces"]),
          selectedPieceDropDown: IdAndName(id: 0, name: ""),
          commentary: TextEditingController(
              text: utf8convert(json["commentary"] ?? "")));
}
