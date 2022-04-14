// To parse this JSON data, do
//
//     final bikeLabelsListModel = bikeLabelsListModelFromJson(jsonString);

import 'dart:convert';

List<BikeLabelsListModel> bikeLabelsListModelFromJson(String str) =>
    List<BikeLabelsListModel>.from(
        json.decode(str).map((x) => BikeLabelsListModel.fromJson(x)));

String bikeLabelsListModelToJson(List<BikeLabelsListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BikeLabelsListModel {
  BikeLabelsListModel({
    required this.veloPk,
    required this.name,
    required this.batterie,
  });

  final int veloPk;
  final String name;
  final String batterie;

  factory BikeLabelsListModel.fromJson(Map<String, dynamic> json) =>
      BikeLabelsListModel(
        veloPk: json["velo_pk"],
        name: json["name"],
        batterie: json["Batterie"] != null ? json["Batterie"] : "",
      );

  Map<String, dynamic> toJson() => {
        "velo_pk": veloPk,
        "name": name,
        "Batterie": batterie,
      };
}
