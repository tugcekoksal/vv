import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/helpers/logger.dart';

class SimpleRobot {
  final WidgetTester tester;
  final log = logger(SimpleRobot);
  int nbErrors = 0;

  SimpleRobot(this.tester);

  Future<void> enterText(String keyLabel, String text) async {
    log.i("Writing text in '" + keyLabel + "' ...");

    final Finder textField;
    try {
      textField = find.byKey(Key(keyLabel));
      await tester.enterText(textField, text);
      await tester.pumpAndSettle();
      log.v("Success!");
    } catch (e) {
      log.d("KeyLabel: '" + keyLabel + "', text: '" + text + "'");
      log.e(e);
      nbErrors += 1;
    }
  }

  Future<void> expectText(String text) async {
    log.i("Expecting text '" + text + "'...");

    final Finder textWidget;
    try {
      expect(find.text(text), findsOneWidget);
      await tester.pumpAndSettle();
      log.v("Success!");
    } catch (e) {
      log.d("Text: '" + text + "'");
      log.e(e);
      nbErrors += 1;
    }
  }

  Future<void> tap(String keyLabel) async {
    log.i("Tap on '" + keyLabel + "' ...");

    final Finder loginButton;
    try {
      loginButton = find.byKey(Key(keyLabel));

      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      log.v("Success!");
    } catch (e) {
      log.d("KeyLabel: '" + keyLabel);
      log.e(e);
      nbErrors += 1;
    }
  }
}
