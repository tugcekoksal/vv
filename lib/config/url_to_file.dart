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
  var docDirectory = await getApplicationDocumentsDirectory();
  String imagePath = docDirectory.path + "/velyvelo";
  String imagePathAndName = imagePath + "/" + imageUrl.split("/").last;
  try {
    // var response = await get(Uri.parse(imageUrl));
    // await Directory(imagePath).create(recursive: true); // <-- 1
    // File file2 = File(imagePathAndName); // <-- 2
    // file2.writeAsBytesSync(response.bodyBytes);
    // print(imagePathAndName);
    var response = await get(Uri.parse(imageUrl));
    final result = await ImageGallerySaver.saveImage(response.bodyBytes);
  } catch (e) {
    print("Error saving url");
    print(e.toString());
    return null;
  }
  return "Enregistré dans la galerie";
}
