// Vendor
import 'dart:convert';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes, allowMalformed: true);
}
