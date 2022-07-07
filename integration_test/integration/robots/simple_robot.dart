import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: avoid_relative_lib_imports
import '../../../lib/helpers/logger.dart';
import '../usefull.dart' as usefull;

class SimpleRobot {
  final WidgetTester tester;
  final log = logger(SimpleRobot, isColored: true);

  SimpleRobot(this.tester);

  Future<void> enterText(String keyLabel, String text) async {
    String info =
        "<Writing text> KeyLabel: '" + keyLabel + "', text: '" + text + "'";
    log.i(info);

    final Finder textField;
    try {
      textField = find.byKey(Key(keyLabel));
      await tester.enterText(textField, text);
      await tester.pumpAndSettle();
      log.v("Success!");
    } catch (e) {
      log.e(e.toString());
      usefull.nbError += 1;
    }
  }

  Future<void> expectText(String text, {int occurences = 1}) async {
    String info = "<Expecting text> Text: '" + text + "'";
    log.i(info);

    try {
      expect(find.text(text), findsNWidgets(occurences));
      await tester.pumpAndSettle();
      log.v("Success!");
    } catch (e) {
      log.e(e.toString());
      usefull.nbError += 1;
    }
  }

  Future<void> expectWidget(String keyLabel, {int occurences = 1}) async {
    String info = "<Expecting Widget> key: '" + keyLabel + "'";
    log.i(info);

    try {
      expect(find.byKey(Key(keyLabel)), findsNWidgets(occurences));
      await tester.pumpAndSettle();
      log.v("Success!");
    } catch (e) {
      log.e(e.toString());
      usefull.nbError += 1;
    }
  }

  Future<void> tap(String keyLabel) async {
    String info = "<Tap on> KeyLabel: '" + keyLabel;
    log.i(info);

    final Finder loginButton;
    try {
      loginButton = find.byKey(Key(keyLabel));

      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      log.v("Success!");
    } catch (e) {
      log.e(e.toString());
      usefull.nbError += 1;
    }
  }
}
