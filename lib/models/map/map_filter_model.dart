// To parse this JSON data, do
//
//     final mapFilterModel = mapFilterModelFromJson(jsonString);

import 'dart:convert';

// Helpers

GroupFilterModel groupFilterModelFromJson(String str) =>
    GroupFilterModel.fromJson(json.decode(str));

class GroupFilterModel {
  GroupFilterModel({
    required this.groups,
  });

  final List<String> groups;

  factory GroupFilterModel.fromJson(Map<String, dynamic> json) =>
      GroupFilterModel(
        groups: List<String>.from(json["groups"].map((x) => x)),
      );
}
