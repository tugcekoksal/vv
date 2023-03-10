import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';

const String pathToListIncidents = "listIncidents";
final log = logger(File);

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _listIncidentsFile async {
  final path = await _localPath;
  return File('$path/$pathToListIncidents.txt');
}

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
    log.e(e.toString());
    return IncidentsModel.empty();
  }
}
