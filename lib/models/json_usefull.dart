import 'dart:ffi';

int? getIntOrNull(dynamic elem) {
  if (elem == null || elem.runtimeType != int) {
    return null;
  }
  return elem;
}

String? getStringOrNull(dynamic elem) {
  if (elem == null || elem.runtimeType != String) {
    return null;
  }
  return elem;
}

bool? getBoolOrNull(dynamic elem) {
  if (elem == null || elem.runtimeType != bool) {
    return null;
  }
  return elem;
}

double? getDoubleFromStringOrNull(dynamic elem) {
  if (elem == null || elem.runtimeType != String) {
    return null;
  }
  return double.tryParse(elem);
}

class IdAndName {
  int? id;
  String? name;

  IdAndName({this.id, this.name});

  factory IdAndName.fromJson(Map<String, dynamic> json) {
    return IdAndName(
        id: getIntOrNull(json["id"]), name: getStringOrNull(json["name"]));
  }
}

List<IdAndName> jsonListToIdAndNameList(jsonList) {
  List<IdAndName> resList = [];

  if (jsonList != null) {
    for (var obj in jsonList) {
      resList.add(IdAndName.fromJson(obj));
    }
  }
  return resList;
}

IdAndName getIdAndNameOrEmpty(dynamic jsonData) {
  if (jsonData == null) {
    return IdAndName();
  }
  try {
    Map<String, dynamic> test = jsonData;
  } catch (e) {
    return IdAndName();
  }
  IdAndName tryElem = IdAndName.fromJson(jsonData);

  if (tryElem.id == null || tryElem.name == null) {
    return IdAndName();
  }
  return tryElem;
}

List<IdAndName> getListIdAndName(dynamic jsonData) {
  List<IdAndName> resList = [];

  if (jsonData == null || jsonData.runtimeType != List) {
    return [];
  }
  for (var obj in jsonData) {
    IdAndName elem = getIdAndNameOrEmpty(obj);
    if (elem.id != null && elem.name != null) {
      resList.add(elem);
    }
  }
  return resList;
}
