// To parse this JSON data, do
//
//     final userBikeModel = userBikeModelFromJson(jsonString);

import 'dart:convert';

List<UserBikeIDModel> userBikeIDModelFromJson(String str) =>
    List<UserBikeIDModel>.from(
        json.decode(str).map((x) => UserBikeIDModel.fromJson(x)));

String userBikeIDModelToJson(List<UserBikeIDModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserBikeIDModel {
  UserBikeIDModel({
    required this.veloPk,
  });

  final int veloPk;

  factory UserBikeIDModel.fromJson(Map<String, dynamic> json) =>
      UserBikeIDModel(
        veloPk: json["velo_pk"] == null ? null : json["velo_pk"],
      );

  Map<String, dynamic> toJson() => {
        "velo_pk": veloPk,
      };
}
