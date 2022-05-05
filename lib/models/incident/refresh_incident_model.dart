// To parse this JSON data, do
//
//     final refreshIncidentModel = refreshIncidentModelFromJson(jsonString);

import 'dart:convert';

String refreshIncidentModelToJson(RefreshIncidentModel data) =>
    json.encode(data.toJson());

class RefreshIncidentModel {
  RefreshIncidentModel({
    required this.statusList,
    this.newestId,
    this.count,
  });

  List<String> statusList;
  final int? newestId;
  final int? count;

  Map<String, dynamic> toJson() => {
        "status_list": List<dynamic>.from(statusList.map((x) => x)),
        if (newestId != null) "newest_id": newestId,
        if (count != null) "count": count
      };
}
