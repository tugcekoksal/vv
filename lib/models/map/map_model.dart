// To parse this JSON data, do
//
//     final mapModel = mapModelFromJson(jsonString);

import 'dart:convert';

List<MapModel> mapModelFromJson(String str) =>
    List<MapModel>.from(json.decode(str).map((x) => MapModel.fromJson(x)));

class MapModel {
  MapModel(
      {required this.veloPk,
      required this.statut,
      required this.pos,
      required this.name,
      required this.group,
      required this.mapStatus});

  final int veloPk;
  final Statut? statut;
  final Pos? pos;
  final String name;
  final String group;
  final String mapStatus;

  factory MapModel.fromJson(Map<String, dynamic> json) => MapModel(
      veloPk: json["velo_pk"] ?? -1,
      statut: json["statut"] == null ? null : Statut.fromJson(json["statut"]),
      pos: json["pos"] == null ? null : Pos.fromJson(json["pos"]),
      name: json["name"] ?? "Pas de nom",
      group: json["group"] ?? "Pas de groupe",
      mapStatus: json["map_status"] ?? "Pas de status");
}

class Pos {
  Pos({
    required this.deviceId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.message,
  });

  final String? deviceId;
  final double? latitude;
  final double? longitude;
  final int? timestamp;
  final String? message;

  factory Pos.fromJson(Map<String, dynamic> json) => Pos(
        deviceId: json["device_id"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        timestamp: json["timestamp"],
        message: json["message"],
      );
}

class Statut {
  Statut({
    required this.name,
    required this.color,
  });

  final String name;
  final String color;

  factory Statut.fromJson(Map<String, dynamic> json) => Statut(
        name: json["name"] ?? "Pas de nom",
        color: json["color"] ?? "Pas de couleur",
      );
}
