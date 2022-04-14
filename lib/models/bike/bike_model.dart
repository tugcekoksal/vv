// To parse this JSON data, do
//
//     final bikeModel = bikeModelFromJson(jsonString);

import 'dart:convert';

BikeModel bikeModelFromJson(String str) => BikeModel.fromJson(json.decode(str));

String bikeModelToJson(BikeModel data) => json.encode(data.toJson());

class BikeModel {
    BikeModel({
        this.clientName,
        this.numeroCadran,
        this.kilometrage,
        this.dateCreation,
        this.pictureUrl,
    });

    final String? clientName;
    final String? numeroCadran;
    final int? kilometrage;
    final String? dateCreation;
    final String? pictureUrl;

    factory BikeModel.fromJson(Map<String, dynamic> json) => BikeModel(
        clientName: json["client_name"] == null ? null : json["client_name"],
        numeroCadran: json["numero_cadran"] == null ? null : json["numero_cadran"],
        kilometrage: json["kilometrage"] == null ? null : json["kilometrage"],
        dateCreation: json["date_creation"] == null ? null : json["date_creation"],
        pictureUrl: json["picture_url"] == null ? null : json["picture_url"],
    );

    Map<String, dynamic> toJson() => {
        "client_name": clientName == null ? null : clientName,
        "numero_cadran": numeroCadran == null ? null : numeroCadran,
        "kilometrage": kilometrage == null ? null : kilometrage,
        "date_creation": dateCreation == null ? null : dateCreation,
        "picture_url": pictureUrl == null ? null : pictureUrl,
    };
}
