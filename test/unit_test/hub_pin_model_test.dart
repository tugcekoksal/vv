import 'dart:convert';
import 'package:test/test.dart';
import 'package:velyvelo/models/hubs/hub_map.dart';

void main() {
  test("hub pin from json (missing)", () {
    final jsonData = json.decode("""{"blbala": "wlenf"}""");
    final HubPinModel hubPin = HubPinModel.fromJson(jsonData);
    expect(hubPin.id, null);
    expect(hubPin.pictureUrl, null);
    expect(hubPin.latitude, null);
    expect(hubPin.longitude, null);
  });
  test("hub pin from json (invalid)", () {
    final Map<String, dynamic> jsonData = {
      "pk": "wlenf",
      "picture": "wfef",
      "latitude": "weg",
      "longitude": "wegw"
    };
    final HubPinModel hubPin = HubPinModel.fromJson(jsonData);
    expect(hubPin.id, null);
    expect(hubPin.pictureUrl, "wfef");
    expect(hubPin.latitude, null);
    expect(hubPin.longitude, null);
  });
  test("hub pin from json (valid)", () {
    final Map<String, dynamic> jsonData = {
      "pk": 4,
      "picture": "url_of_picture",
      "latitude": "5.0",
      "longitude": "10.77"
    };
    final HubPinModel hubPin = HubPinModel.fromJson(jsonData);
    expect(hubPin.id, 4);
    expect(hubPin.pictureUrl, "url_of_picture");
    expect(hubPin.latitude, 5.0);
    expect(hubPin.longitude, 10.77);
  });
}
