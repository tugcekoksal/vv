import 'dart:convert';

import 'package:velyvelo/models/json_usefull.dart';

List<HubListModel> hubListModelFromJson(String str) =>
    List<HubListModel>.from(json.decode(str).map((x) {
      return HubListModel.fromJson(x);
    })).toList();

class HubListModel {
  HubListModel(
      {this.name,
      this.clientName,
      this.reparationsNb,
      this.usersNb,
      this.parkedNb,
      this.usedNb,
      this.robbedNb,
      this.adress});

  final String? name;
  final String? clientName;
  final int? reparationsNb;
  final int? usersNb;
  final int? parkedNb;
  final int? usedNb;
  final int? robbedNb;
  final String? adress;

  factory HubListModel.fromJson(Map<String, dynamic> json) {
    String? adressOrNull = getStringOrNull(json["adress"]);
    if (adressOrNull == "") {
      adressOrNull = null;
    }
    return HubListModel(
        name: getStringOrNull(json["name"]),
        clientName: getStringOrNull(json["client_name"]),
        reparationsNb: getIntOrNull(json["reparations"]),
        usersNb: getIntOrNull(json["users"]),
        parkedNb: getIntOrNull(json["parked"]),
        usedNb: getIntOrNull(json["used"]),
        robbedNb: getIntOrNull(json["robbed"]),
        adress: adressOrNull);
  }
}
