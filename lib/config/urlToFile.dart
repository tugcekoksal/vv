import 'dart:io';

import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<File> urlToFile(String imageUrl) async {
  var rng = new Random();

  // Create the emplacement for the file
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');

  // Get the image and writes the bytes
  http.Response response = await http.get(Uri.parse(imageUrl));
  await file.writeAsBytes(response.bodyBytes);
  return file;
}
