import 'package:velyvelo/models/json_usefull.dart';

List<IncidentPieces> jsonToListIncidentPieces(List<dynamic> json) {
  List<IncidentPieces> listIncidentPieces =
      json.map((elem) => IncidentPieces.fromJson(elem)).toList();
  return listIncidentPieces;
}

List<Map<String, dynamic>> listIncidentPiecesToListJson(
    List<IncidentPieces> incidentPieces) {
  List<Map<String, dynamic>> listJson =
      incidentPieces.map((elem) => elem.toJson()).toList();
  return listJson;
}

class IncidentPieces {
  IncidentPieces({
    required this.reparationId,
    required this.pieces,
  });

  final int reparationId;
  final List<IdAndName> pieces;

  factory IncidentPieces.fromJson(Map<String, dynamic> json) {
    return IncidentPieces(
      reparationId: int.parse(json.keys.first),
      pieces: getListIdAndNameFromListJson(json[json.keys.first]),
    );
  }

  Map<String, dynamic> toJson() {
    return {reparationId.toString(): getJsonListFromListIdAndName(pieces)};
  }
}
