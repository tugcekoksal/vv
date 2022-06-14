import 'dart:convert';

import 'package:velyvelo/models/json_usefull.dart';

List<HubMapModel> hubMapModelFromJson(String str) =>
    List<HubMapModel>.from(json.decode(str).map((x) {
      return HubMapModel.fromJson(x);
    })).toList();

class HubMapModel {
  HubMapModel({
    this.id,
    this.pictureUrl,
    this.latitude,
    this.longitude,
  });

  final int? id;
  final String? pictureUrl;
  final double? latitude;
  final double? longitude;

  factory HubMapModel.fromJson(Map<String, dynamic> json) => HubMapModel(
        id: getIntOrNull(json["id"]),
        pictureUrl: getStringOrNull(json["picture"]),
        latitude: getDoubleFromStringOrNull(json["latitude"]),
        longitude: getDoubleFromStringOrNull(json["longitude"]),
      );
}
