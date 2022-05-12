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
  });

  final int veloPk;
  final String name;

  factory BikeLabelsListModel.fromJson(Map<String, dynamic> json) =>
      BikeLabelsListModel(
        veloPk: json["velo_pk"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "velo_pk": veloPk,
        "name": name,
      };
}
