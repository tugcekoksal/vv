// To parse this JSON data, do
//
//     final bikeModel = bikeModelFromJson(jsonString);

import 'dart:convert';

HubModel hubsModelFromJson(String str) => HubModel.fromJson(json.decode(str));

class HubModel {
  HubModel({
    this.groupName,
    this.clientName,
    this.reparations,
    this.users,
    this.bikeParked,
    this.bikeUsed,
    this.bikeRobbed,
    this.adresse,
  });

  final String? groupName;
  final String? clientName;
  final int? reparations;
  final int? users;
  final int? bikeParked;
  final int? bikeUsed;
  final int? bikeRobbed;
  final String? adresse;

  factory HubModel.fromJson(Map<String, dynamic> json) => HubModel(
        groupName: json["nom"] ?? "",
        clientName: json["client"] ?? "",
        reparations: json["reparations"] ?? 0,
        users: json["users"] ?? 0,
        bikeParked: json["Rangés"] ?? 0,
        bikeUsed: json["Utilisés"] ?? 0,
        bikeRobbed: json["Volés"] ?? 0,
        adresse: json["adresse"] ??
            ", " + json["ville"] ??
            " " + json["code_postal"] ??
            "",
      );
}

List<HubPinModel> hubsPinModelFromJson(String str) => List<HubPinModel>.from(
    json.decode(str).map((x) => HubPinModel.fromJson(x)));

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

  factory HubPinModel.fromJson(Map<String, dynamic> json) => HubPinModel(
        id: json["pk"] ?? -1,
        pictureUrl: json["picture"] ?? "",
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
      );
}
