// To parse this JSON data, do
//
//     final mapFilterModel = mapFilterModelFromJson(jsonString);

import 'dart:convert';

// Helpers
import 'package:velyvelo/helpers/utf8_convert.dart';

MapFilterModel mapFilterModelFromJson(String str) => MapFilterModel.fromJson(json.decode(utf8convert(str)));

String mapFilterModelToJson(MapFilterModel data) => json.encode(data.toJson());

class MapFilterModel {
    MapFilterModel({
        required this.hasAccessGroups,
        required this.hasAccessStatus,
        required this.groups,
        required this.status,
    });

    final bool hasAccessGroups;
    final bool hasAccessStatus;
    final List<String> groups;
    final List<String> status;

    factory MapFilterModel.fromJson(Map<String, dynamic> json) => MapFilterModel(
        hasAccessGroups: json["has_access_groups"],
        hasAccessStatus: json["has_access_status"],
        groups: List<String>.from(json["groups"].map((x) => x)),
        status: List<String>.from(json["status"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "has_access_groups": hasAccessGroups,
        "has_access_status": hasAccessStatus,
        "groups": List<dynamic>.from(groups.map((x) => x)),
        "status": List<dynamic>.from(status.map((x) => x)),
    };
}
