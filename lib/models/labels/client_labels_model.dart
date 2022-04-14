// To parse this JSON data, do
//
//     final ClientLabelsListModel = ClientLabelsListModelFromJson(jsonString);

import 'dart:convert';

List<ClientLabelsListModel> clientLabelsListModelFromJson(String str) =>
    List<ClientLabelsListModel>.from(
        json.decode(str).map((x) => ClientLabelsListModel.fromJson(x)));

class ClientLabelsListModel {
  ClientLabelsListModel({
    required this.clientPk,
    required this.name,
  });

  final int clientPk;
  final String name;

  factory ClientLabelsListModel.fromJson(Map<String, dynamic> json) =>
      ClientLabelsListModel(
        clientPk: json["pk"],
        name: json["numero_client"],
      );
}
