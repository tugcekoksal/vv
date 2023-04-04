import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velyvelo/models/json_usefull.dart';

class StorageUtil {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveIdAndNameList(
      String key, List<IdAndName> idAndNameList) async {
    final jsonString =
        jsonEncode(idAndNameList.map((e) => e.toJson()).toList());
    await _preferences.setString(key, jsonString);
  }

  static List<IdAndName> loadIdAndNameList(String key) {
    final jsonString = _preferences.getString(key);
    if (jsonString == null) {
      return [];
    }
    List<dynamic> decodedJsonList = jsonDecode(jsonString);
    return decodedJsonList.map((e) => IdAndName.fromJson(e)).toList();
  }
}
