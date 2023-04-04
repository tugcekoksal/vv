// To parse this JSON data, do
//
//     final ClientType = ClientTypeFromJson(jsonString);

import 'dart:convert';

UserType clientTypeFromJson(dynamic json) => UserType.fromJson(json);

String clientTypeToJson(UserType data) => json.encode(data.toJson());

class UserType {
  UserType({required this.userType, this.clientType});

  final String userType;
  final String? clientType;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
      userType: json["user_type"] ?? "No role assigned",
      clientType: json["client_type"]);

  Map<String, dynamic> toJson() =>
      {"user_type": userType, "client_type": clientType};
}
