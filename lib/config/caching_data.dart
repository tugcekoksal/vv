import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/incident/client_card_model.dart';
import 'package:velyvelo/models/incident/group_card_model.dart';
import 'package:velyvelo/models/incident/incident_card_model.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/models/incident/incident_pieces.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/models/json_usefull.dart';
import 'package:velyvelo/screens/views/incidents/components/incident_card.dart';
import 'package:velyvelo/services/bikes/send_bike_status_service.dart';

const String pathToListClientIncidents = "listClientIncidents";
const String pathToListGroupIncidents = "listGroupIncidents";
const String pathToListIncidents = "listIncidents";

const String pathToQueueUpdateIncidents = "queueUpdateIncidents";

const String pathToIncidentPieces = "incidentPieces";

final log = logger(File);

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _listClientIncidentsFile async {
  final path = await _localPath;
  return File('$path/$pathToListClientIncidents.txt');
}

Future<File> get _listGroupIncidentsFile async {
  final path = await _localPath;
  return File('$path/$pathToListGroupIncidents.txt');
}

Future<File> get _listIncidentsFile async {
  final path = await _localPath;
  return File('$path/$pathToListIncidents.txt');
}

Future<File> get _queueUpdateIncidentsFile async {
  final path = await _localPath;
  return File('$path/$pathToQueueUpdateIncidents.txt');
}

Future<File> get _incidentPiecesFile async {
  final path = await _localPath;
  return File('$path/$pathToIncidentPieces.txt');
}

Future<void> initCacheFiles() async {
  final file1 = await _listClientIncidentsFile;
  final file2 = await _listGroupIncidentsFile;
  final file3 = await _listIncidentsFile;
  final file4 = await _queueUpdateIncidentsFile;
  final file5 = await _incidentPiecesFile;

  file1.create(recursive: true);
  file2.create(recursive: true);
  file3.create(recursive: true);
  file4.create(recursive: true);
  file5.create(recursive: true);
}

Future<void> writeListClientIncidents(List<ClientCardModel> clientCards) async {
  final file = await _listClientIncidentsFile;

  // Write the file
  try {
    file.writeAsString(json.encode(clientCards));
  } catch (e) {
    file.writeAsString("");
  }
}

Future<void> writeListGroupIncidents(
    List<GroupCardModel> groupCards, int idClient) async {
  final file = await _listGroupIncidentsFile;

  try {
    // Read the file
    final stringContent = await file.readAsString();
    var jsonContent = json.decode(stringContent);
    if (jsonContent.runtimeType != List) jsonContent = [];

    bool exists = false;
    for (var elem in jsonContent) {
      if (elem["client_id"] == idClient) {
        elem["data"] = groupCardsToJson(groupCards);
        exists = true;
        break;
      }
    }
    if (!exists) {
      jsonContent
          .add({"client_id": idClient, "data": groupCardsToJson(groupCards)});
    }
    file.writeAsString(json.encode(jsonContent));
  } catch (e) {
    file.writeAsString(json.encode(""));
    log.e("writeListGroupIncidents: " + e.toString());
  }
}

Future<void> writeListIncidents(
    List<IncidentCardModel> incidentCards, int idGroup) async {
  final file = await _listGroupIncidentsFile;

  try {
    // Read the file
    final stringContent = await file.readAsString();
    var jsonContent = json.decode(stringContent);
    if (jsonContent.runtimeType != List) jsonContent = [];

    bool exists = false;
    for (var elem in jsonContent) {
      if (elem["group_id"] == idGroup) {
        elem["data"] = incidentCardsToJson(incidentCards);
        exists = true;
        break;
      }
    }
    if (!exists) {
      jsonContent.add(
          {"group_id": idGroup, "data": incidentCardsToJson(incidentCards)});
    }
    file.writeAsString(json.encode(jsonContent));
  } catch (e) {
    file.writeAsString(json.encode(""));
    log.e("writeListIncidents: " + e.toString());
  }
}

Future<List<ClientCardModel>> readListClientIncidents() async {
  try {
    final file = await _listClientIncidentsFile;

    // Read the file
    final stringContent = await file.readAsString();
    final jsonContent = json.decode(stringContent);
    final clientIncidents = clientCardsListFromJson(jsonContent);
    return clientIncidents;
  } catch (e) {
    // If encountering an error, return nothing
    log.e("readListClientIncidents: " + e.toString());
    return [];
  }
}

Future<List<GroupCardModel>> readListGroupIncidents(int idClient) async {
  try {
    final file = await _listGroupIncidentsFile;

    // Read the file
    final stringContent = await file.readAsString();
    final jsonContent = json.decode(stringContent);

    for (var elem in jsonContent) {
      if (elem["client_id"] == idClient) {
        return groupCardsListCacheFromJson(elem["data"]);
      }
    }
    return [];
  } catch (e) {
    // If encountering an error, return nothing
    log.e("readListGroupIncidents: " + e.toString());
    return [];
  }
}

Future<List<IncidentCardModel>> readListIncidents(int idGroup) async {
  try {
    final file = await _listGroupIncidentsFile;

    // Read the file
    final stringContent = await file.readAsString();
    final jsonContent = json.decode(stringContent);

    for (var elem in jsonContent) {
      if (elem["group_id"] == idGroup) {
        return incidentCardsListFromJson(elem["data"]);
      }
    }
    return [];
  } catch (e) {
    // If encountering an error, return nothing
    log.e("readListIncidents: " + e.toString());
    return [];
  }
}

// Updating incidents
Future<void> writeUpdateIncident(List<ReparationModel> reparationsQueue) async {
  final file = await _queueUpdateIncidentsFile;

  // Write the file
  file.writeAsString(
      json.encode(listReparationModelToListJson(reparationsQueue)),
      flush: true);
}

Future<List<ReparationModel>> readUpdateIncident() async {
  final file = await _queueUpdateIncidentsFile;
  try {
    // Read the file
    final stringContent = await file.readAsString();
    final jsonContent = json.decode(stringContent);
    final reparations = jsonToListReparationModel(jsonContent);
    return reparations;
  } catch (e) {
    // If encountering an error, return nothing
    log.e("readUpdateIncident:" + e.toString());
    return [];
  }
}

Future<void> writeIncidentPieces(List<IncidentPieces> incidentPieces) async {
  final file = await _incidentPiecesFile;

  // Write the file
  try {
    file.writeAsString(
        json.encode(listIncidentPiecesToListJson(incidentPieces)));
  } catch (e) {
    file.writeAsString("");
  }
}

Future<List<IncidentPieces>> readIncidentPieces() async {
  final file = await _incidentPiecesFile;
  try {
    // Read the file
    final stringContent = await file.readAsString();
    final jsonContent = json.decode(stringContent);
    final incidentPieces = jsonToListIncidentPieces(jsonContent);
    return incidentPieces;
  } catch (e) {
    // If encountering an error, return nothing
    log.e("readIncidentPieces:" + e.toString());
    return [];
  }
}
