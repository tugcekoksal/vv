List<GroupCardModel> groupCardsListFromJson(Map<String, dynamic> json) {
  List<dynamic> jsonGroups = json["groups"];
  List<GroupCardModel> groupList =
      jsonGroups.map((e) => GroupCardModel.fromJson(e)).toList();
  if (json.containsKey("no_group")) {
    GroupCardModel noGroup = GroupCardModel.fromJson(json["no_group"]);
    groupList.insert(0, noGroup);
  }

  return groupList;
}

List<GroupCardModel> groupCardsListCacheFromJson(List<dynamic> jsonGroups) {
  List<GroupCardModel> groupList =
      jsonGroups.map((e) => GroupCardModel.fromJson(e)).toList();
  return groupList;
}

List<Map<String, dynamic>> groupCardsToJson(List<GroupCardModel> groupCards) {
  return groupCards.map((elem) => elem.toJson()).toList();
}

class GroupCardModel {
  final int id;
  final String name;
  final String adresse;
  final int nbReparation;
  final int nbVelo;

  GroupCardModel(
      {required this.id,
      required this.name,
      required this.adresse,
      required this.nbReparation,
      required this.nbVelo});

  factory GroupCardModel.empty() => GroupCardModel(
      id: -1, name: "-NAME-", adresse: "-ADRESSE-", nbReparation: 0, nbVelo: 0);

  factory GroupCardModel.fromJson(Map<String, dynamic> json) => GroupCardModel(
      id: json["id"] ?? -1,
      name: json["name"] ?? "Pas d'enseigne",
      adresse: json["adresse"] == null || json["adresse"] == ""
          ? "Pas d'adresse"
          : json["adresse"],
      nbReparation: json["nb_reparation"] ?? 0,
      nbVelo: json["nb_velo"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "adresse": adresse,
        "nb_reparation": nbReparation,
        "nb_velo": nbVelo,
      };
}
