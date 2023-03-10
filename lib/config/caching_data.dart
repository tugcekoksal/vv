import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';

const String pathToListIncidents = "listIncidents";
const String pathToQueueUpdateIncidents = "queueUpdateIncidents";
final log = logger(File);

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _listIncidentsFile async {
  final path = await _localPath;
  return File('$path/$pathToListIncidents.txt');
}

Future<File> get _queueUpdateIncidentsFile async {
  final path = await _localPath;
  return File('$path/$pathToQueueUpdateIncidents.txt');
}

// Reading incidents
Future<File> writeListIncidents(IncidentsModel incidents) async {
  final file = await _listIncidentsFile;

  // Write the file
  return file.writeAsString(json.encode(incidents.toJson()));
}

Future<IncidentsModel> readListIncidents() async {
  try {
    final file = await _listIncidentsFile;

    // Read the file
    final stringContent = await file.readAsString();
    final jsonContent = json.decode(stringContent);
    final incidents = IncidentsModel.fromJson(jsonContent);
    return incidents;
  } catch (e) {
    // If encountering an error, return nothing
    log.e("readListIncidents: " + e.toString());
    return IncidentsModel.empty();
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
