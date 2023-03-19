import 'dart:io';

import 'dart:math';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<File> urlToFile(String imageUrl) async {
  var rng = Random();

  // Create the emplacement for the file
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  File file = File(tempPath + (rng.nextInt(100)).toString() + '.png');

  // Get the image and writes the bytes
  http.Response response = await http.get(Uri.parse(imageUrl));
  await file.writeAsBytes(response.bodyBytes);
  return file;
}

Future<String?> saveImageFromUrl(String imageUrl) async {
  try {
    var response = await get(Uri.parse(imageUrl));
    await ImageGallerySaver.saveImage(response.bodyBytes);
  } catch (e) {
    return null;
  }
  return "Enregistré dans la galerie";
}
