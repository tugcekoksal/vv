// To parse this JSON data, do
//
//     final incidentLabelsModel = incidentLabelsModelFromJson(jsonString);

import 'dart:convert';

// Helpers

List<String> incidentLabelsModelFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String incidentLabelsModelToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
