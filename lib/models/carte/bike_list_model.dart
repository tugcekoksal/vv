import 'dart:convert';

import 'package:velyvelo/models/json_usefull.dart';
import 'package:intl/intl.dart';

List<BikeListModel> bikeListModelFromJson(String str) {
  // Check if when encoded is a list
  return List<BikeListModel>.from(
      json.decode(str).map((x) => BikeListModel.fromJson(x)));
}

class BikeListModel {
  BikeListModel(
      {required this.id,
      required this.name,
      required this.groupName,
      required this.mapStatus});

  final int? id;
  final String? name;
  final String? groupName;
  final String? mapStatus;

  factory BikeListModel.fromJson(Map<String, dynamic> json) {
    String? status = getStringOrNull(json["map_status"]);
    if (status == "") {
      status = null;
    }
    return BikeListModel(
        id: getIntOrNull(json["id"]),
        name: getStringOrNull(json["name"]),
        groupName: getStringOrNull(json["group_name"]),
        mapStatus: status);
  }
}

String? getLastEmissionOrNull(int? timestamp) {
  int? stamp = timestamp;
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(stamp != null ? stamp * 1000 : 0);
  String? result =
      stamp != null ? DateFormat('dd-MM-yyyy - kk:mm').format(date) : null;
  return result;
}

class BikePopupModel extends BikeListModel {
  String? timestamp;
  BikePopupModel(
      {super.id,
      super.name,
      super.groupName,
      super.mapStatus,
      required this.timestamp});

  factory BikePopupModel.fromJson(Map<String, dynamic> json) {
    String? status = getStringOrNull(json["map_status"]);
    if (status == "") {
      status = null;
    }
    return BikePopupModel(
        id: getIntOrNull(json["id"]),
        name: getStringOrNull(json["name"]),
        groupName: getStringOrNull(json["group_name"]),
        mapStatus: status,
        timestamp: getLastEmissionOrNull(getIntOrNull(json["timestamp"])));
  }
}
