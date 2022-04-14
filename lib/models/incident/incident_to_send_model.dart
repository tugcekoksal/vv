// To parse this JSON data, do
//
//     final incidentToSendModel = incidentToSendModelFromJson(jsonString);

import 'dart:io';

import 'dart:convert';

String incidentToSendModelToJson(IncidentToSendModel data) =>
    json.encode(data.toJson());

class IncidentToSendModel {
  IncidentToSendModel({
    required this.veloPk,
    required this.type,
    required this.commentary,
    required this.files,
  });

  final String veloPk;
  final String type;
  final String commentary;
  final List<File> files;

  Map<String, dynamic> toJson() => {
        "velo_pk": veloPk,
        "type": type,
        "commentary": commentary,
        "files": List<File>.from(files.map((x) => x)),
      };
}
