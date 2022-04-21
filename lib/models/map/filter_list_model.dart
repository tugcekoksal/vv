// To parse this JSON data, do
//
//     final filterListModel = filterListModelFromJson(jsonString);

import 'dart:convert';

String filterListModelToJson(FilterListModel data) =>
    json.encode(data.toJson());

class FilterListModel {
  FilterListModel({
    required this.filters,
  });

  final Filters filters;

  Map<String, dynamic> toJson() => {
        "filters": filters.toJson(),
      };
}

class Filters {
  Filters({
    required this.groupes,
    required this.statusUsing,
  });

  final List<String> groupes;
  final List<String> statusUsing;

  Map<String, dynamic> toJson() => {
        "groupes": List<dynamic>.from(groupes.map((x) => x)),
        "status_using": List<dynamic>.from(
            statusUsing.map((x) => x.substring(0, x.length - 1)))
      };
}
