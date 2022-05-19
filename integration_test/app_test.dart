import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:velyvelo/main.dart' as app;

import 'dart:io';
import 'package:path/path.dart';

void main() {
  // setUpAll(() async {
  // await
  // Process.run("applesimutils", [
  //   '--byId',
  //   '"412E6C3C-0C11-401D-96A6-9160AA66340E"',
  //   '--bundle',
  //   '"com.grafenit.velyvelo"',
  //   '--setPermissions',
  //   '"notifications=YES"'
  // ]);
  // });
  group('App test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Full app test', (tester) async {
      app.main(testing: true);
      await tester.pumpAndSettle();

      final Finder usernameFormField = find.byType(TextField).first;
      final Finder passwordFormField = find.byType(TextField).last;
      final Finder loginButton = find.bySemanticsLabel("Se connecter").first;

      await tester.enterText(usernameFormField, "kilianadmin");
      await tester.enterText(passwordFormField, "mdp-kiki");
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    });
  });
}
