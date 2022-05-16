// To parse this JSON data, do
//
//     final groupLabelsListModel = groupLabelsListModelFromJson(jsonString);

import 'dart:convert';

// Helpers

List<GroupLabelsListModel> groupLabelsListModelFromJson(String str) =>
    List<GroupLabelsListModel>.from(
        json.decode(str).map((x) => GroupLabelsListModel.fromJson(x)));

String groupLabelsListModelToJson(List<GroupLabelsListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupLabelsListModel {
  GroupLabelsListModel({
    required this.groupePk,
    required this.name,
  });

  final int groupePk;
  final String name;

  factory GroupLabelsListModel.fromJson(Map<String, dynamic> json) =>
      GroupLabelsListModel(
        groupePk: json["groupe_pk"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "groupe_pk": groupePk,
        "name": name,
      };
}
