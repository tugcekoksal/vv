List<ClientCardModel> clientCardsListFromJson(List json) {
  List<ClientCardModel> likesList =
      json.map((e) => ClientCardModel.fromJson(e)).toList();
  return likesList;
}

class ClientCardModel {
  final int id;
  final String name;
  final String label;
  final String address;
  final int nbReparation;

  ClientCardModel(
      {required this.id,
      required this.name,
      required this.label,
      required this.address,
      required this.nbReparation});

  factory ClientCardModel.empty() => ClientCardModel(
      id: -1,
      name: "-NAME-",
      label: "-LABEL-",
      address: "-ADDRESS-",
      nbReparation: 0);

  factory ClientCardModel.fromJson(Map<String, dynamic> json) =>
      ClientCardModel(
          id: json["id"] ?? -1,
          name: json["enseigne"] ?? "Pas d'enseigne",
          label: json["denomination_social"] ?? "",
          address: json["adresse_enseigne"] ?? "Pas d'adresse",
          nbReparation: json["nb_reparation"] ?? 0);

  Map<String, dynamic> toJson() => {};
}
