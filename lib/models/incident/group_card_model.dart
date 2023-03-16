List<GroupCardModel> groupCardsListFromJson(Map<String, dynamic> json) {
  GroupCardModel noGroup = GroupCardModel.fromJson(json["no_group"]);
  List<dynamic> jsonGroups = json["groups"];
  List<GroupCardModel> groupList =
      jsonGroups.map((e) => GroupCardModel.fromJson(e)).toList();
  groupList.insert(0, noGroup);
  return groupList;
}

class GroupCardModel {
  final int id;
  final String name;
  final int nbReparation;
  final int nbVelo;

  GroupCardModel(
      {required this.id,
      required this.name,
      required this.nbReparation,
      required this.nbVelo});

  factory GroupCardModel.empty() =>
      GroupCardModel(id: -1, name: "-NAME-", nbReparation: 0, nbVelo: 0);

  factory GroupCardModel.fromJson(Map<String, dynamic> json) => GroupCardModel(
      id: json["id"] ?? -1,
      name: json["name"] ?? "Pas d'enseigne",
      nbReparation: json["nb_reparation"] ?? 0,
      nbVelo: json["nb_velo"] ?? 0);

  Map<String, dynamic> toJson() => {};
}
