import 'dart:convert';
import 'dart:io';

dynamic jsonFileToJson(String relativePath) async {
  final file = File("test/unit_test/json/$relativePath");
  final json = jsonDecode(await file.readAsString());
  return json;
}
