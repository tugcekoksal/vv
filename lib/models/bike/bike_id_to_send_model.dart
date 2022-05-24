// To parse this JSON data, do
//
//     final userBikeIdToSend = userBikeIdToSendFromJson(jsonString);

import 'dart:convert';

UserBikeIdToSend userBikeIdToSendFromJson(String str) =>
    UserBikeIdToSend.fromJson(json.decode(str));

String userBikeIdToSendToJson(UserBikeIdToSend data) =>
    json.encode(data.toJson());

class UserBikeIdToSend {
  UserBikeIdToSend({
    required this.veloPk,
  });

  final int veloPk;

  factory UserBikeIdToSend.fromJson(Map<String, dynamic> json) =>
      UserBikeIdToSend(
        veloPk: json["velo_pk"] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "velo_pk": veloPk,
      };
}
