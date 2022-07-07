// To parse this JSON data, do
//
//     final bikeModel = bikeModelFromJson(jsonString);

import 'dart:convert';

import 'package:velyvelo/models/json_usefull.dart';

List<HubModel> hubsModelFromJson(String str) =>
    List<HubModel>.from(json.decode(str).map((x) {
      return HubModel.fromJson(x);
    })).toList();

class HubModel {
  HubModel(
      {this.groupName,
      this.clientName,
      this.reparations,
      this.users,
      this.bikeParked,
      this.bikeUsed,
      this.bikeRobbed,
      required this.adresse,
      required this.pinModel});

  final String? groupName;
  final String? clientName;
  final int? reparations;
  final int? users;
  final int? bikeParked;
  final int? bikeUsed;
  final int? bikeRobbed;
  final String adresse;
  final HubPinModel pinModel;

  factory HubModel.fromJson(Map<String, dynamic> json) => HubModel(
        groupName: json["infos"]["nom"] ?? "",
        clientName: json["infos"]["client"] ?? "",
        reparations: json["infos"]["reparations"],
        users: json["infos"]["users"],
        bikeParked: json["infos"]["Rangés"],
        bikeUsed: json["infos"]["Utilisés"],
        bikeRobbed: json["infos"]["Volés"],
        adresse: json["infos"]["adresse"] ?? "",
        pinModel: HubPinModel.fromJson(json["map"]),
      );
}

class HubPinModel {
  HubPinModel({
    this.id,
    this.pictureUrl,
    this.latitude,
    this.longitude,
  });

  final int? id;
  final String? pictureUrl;
  final double? latitude;
  final double? longitude;

  factory HubPinModel.fromJson(Map<String, dynamic> json) {
    return HubPinModel(
      id: getIntOrNull(json["pk"]),
      pictureUrl: getStringOrNull(json["picture"]),
      latitude: getDoubleFromStringOrNull(json["latitude"]),
      longitude: getDoubleFromStringOrNull(json["longitude"]),
    );
  }
}
