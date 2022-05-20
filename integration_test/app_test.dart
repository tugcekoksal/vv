import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:velyvelo/main.dart' as app;

import 'dart:io';
import 'package:path/path.dart';

// void login(String username, String password) {
//   return testWidgets('Login', (tester) async {
//     app.main(testing: true);
//     await tester.pumpAndSettle();

//     final Finder usernameFormField = find.byType(TextField).first;
//     final Finder passwordFormField = find.byType(TextField).last;
//     final Finder loginButton = find.bySemanticsLabel("Se connecter").first;

//     await tester.enterText(usernameFormField, username);
//     await tester.enterText(passwordFormField, password);
//     await tester.pumpAndSettle();

//     await tester.tap(loginButton);
//     await tester.pumpAndSettle();
//   });
// }

void main() {
  group('App test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Login', (tester) async {
      app.main(testing: true);
      await tester.pumpAndSettle();

      final Finder usernameFormField = find.byType(TextField).first;
      final Finder passwordFormField = find.byType(TextField).last;
      final Finder loginButton = find.byKey(Key("login-button")).first;

      await tester.enterText(usernameFormField, "kilianadmin");
      await tester.enterText(passwordFormField, "mdp-kiki");
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    });
  });
}
