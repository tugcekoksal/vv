import 'package:shared_preferences/shared_preferences.dart';

Future<String> getTokenFromSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("token") ?? "";
}

class ItemRefresher {
  int? newestId;
  int? count;

  void actualize(int? firstId, int? listLen) {
    newestId = firstId;
    count = listLen;
  }

  Map<String, dynamic> toJson() => {
        if (newestId != null) "newest_id": newestId,
        if (count != null) "count": count
      };
}
