import 'dart:convert';

import 'package:velyvelo/models/json_usefull.dart';

List<BikeMapModel> bikeMapModelFromJson(String str) {
  // Check if when encoded is a list
  return List<BikeMapModel>.from(
      json.decode(str).map((x) => BikeMapModel.fromJson(x)));
}

class BikeMapModel {
  BikeMapModel(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.mapStatus});

  final int? id;
  final double? latitude;
  final double? longitude;
  final String? mapStatus;

  factory BikeMapModel.fromJson(Map<String, dynamic> json) {
    return BikeMapModel(
        id: getIntOrNull(json["id"]),
        latitude: getDoubleOrNull(json["latitude"]),
        longitude: getDoubleOrNull(json["longitude"]),
        mapStatus: getStringOrNull(json["map_status"]));
  }
}
