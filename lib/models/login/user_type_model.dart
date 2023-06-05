// To parse this JSON data, do
//
//     final ClientType = ClientTypeFromJson(jsonString);

import 'dart:convert';

UserType clientTypeFromJson(dynamic json) => UserType.fromJson(json);

String clientTypeToJson(UserType data) => json.encode(data.toJson());

class UserType {
  UserType({required this.userType, this.clientType, required this.firstName, required this.lastName, required this.email, this.phone});

  final String userType;
  final String firstName;
  final String lastName;
  final String email;
  final String? clientType;
  final String? phone;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
      userType: json["user_type"] ?? "No role assigned",
      clientType: json["client_type"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      phone: json["phone"],
      );

  Map<String, dynamic> toJson() =>
      {
        "user_type": userType,
        "client_type": clientType,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
      };
}
