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

double? getDoubleOrNull(dynamic elem) {
  if (elem == null || elem.runtimeType != double) {
    return null;
  }
  return elem;
}

class IdAndName {
  int? id;
  String? name;

  IdAndName({this.id, this.name});

  factory IdAndName.fromJson(Map<String, dynamic> json) {
    return IdAndName(
        id: getIntOrNull(json["id"]), name: getStringOrNull(json["name"]));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

List<Map<String, dynamic>> idAndNameListToJson(List<IdAndName> list) {
  List<Map<String, dynamic>> newList = [];
  for (var idandname in list) {
    newList.add(idandname.toJson());
  }
  return newList;
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
