// To parse this JSON data, do
//
//     final bikeModel = bikeModelFromJson(jsonString);

import 'dart:convert';

List<HubModel> hubsModelFromJson(String str) =>
    List<HubModel>.from(json.decode(str).map((x) => HubModel.fromJson(x)));

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
      this.pinModel});

  final String? groupName;
  final String? clientName;
  final int? reparations;
  final int? users;
  final int? bikeParked;
  final int? bikeUsed;
  final int? bikeRobbed;
  final String adresse;
  final HubPinModel? pinModel;

  factory HubModel.fromJson(Map<String, dynamic> json) => HubModel(
        groupName: json["infos"]["nom"] ?? "",
        clientName: json["infos"]["client"] ?? "",
        reparations: json["infos"]["reparations"] ?? 0,
        users: json["infos"]["users"] ?? 0,
        bikeParked: json["infos"]["Rangés"] ?? 0,
        bikeUsed: json["infos"]["Utilisés"] ?? 0,
        bikeRobbed: json["infos"]["Volés"] ?? 0,
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

  factory HubPinModel.fromJson(Map<String, dynamic> json) => HubPinModel(
        id: json["pk"] ?? -1,
        pictureUrl: json["picture"] ?? "",
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
      );
}
