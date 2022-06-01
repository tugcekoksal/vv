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

double? getDoubleFromStringOrNull(dynamic elem) {
  if (elem == null || elem.runtimeType != String) {
    return null;
  }
  return double.tryParse(elem);
}
