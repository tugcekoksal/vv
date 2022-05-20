import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velyvelo/main.dart' as app;

import 'dart:io';
import 'package:path/path.dart';

import '../lib/helpers/logger.dart';
import 'robots/simple_robot.dart';

const String username = "kilianadmin";
const String password = "mdp-kiki";

void main() {
  int nbErrors = 0;
  group('[Test login]', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Error missing username', (WidgetTester tester) async {
      app.main(testing: true);
      await tester.pumpAndSettle();

      SimpleRobot simpleRobot = SimpleRobot(tester);

      await simpleRobot.tap("login-button");
      await simpleRobot.expectText("Le champ identifiant ne peut être vide");

      nbErrors += simpleRobot.nbErrors;
    });

    testWidgets('Error missing password', (WidgetTester tester) async {
      app.main(testing: true);
      await tester.pumpAndSettle();

      SimpleRobot simpleRobot = SimpleRobot(tester);

      await simpleRobot.enterText("login-username", "kilianadmin");
      await simpleRobot.tap("login-button");
      await simpleRobot.expectText("Le champ mot de passe ne peut être vide");

      nbErrors += simpleRobot.nbErrors;
    });

    testWidgets('Error bad informations', (WidgetTester tester) async {
      app.main(testing: true);
      await tester.pumpAndSettle();

      SimpleRobot simpleRobot = SimpleRobot(tester);

      await simpleRobot.enterText("login-username", "error_username");
      await simpleRobot.enterText("login-password", "error_password");
      await simpleRobot.tap("login-button");
      await simpleRobot.expectText("Mauvais message d'erreur");

      nbErrors += simpleRobot.nbErrors;
    });

    testWidgets('Valid login', (WidgetTester tester) async {
      app.main(testing: true);
      await tester.pumpAndSettle();

      SimpleRobot simpleRobot = SimpleRobot(tester);

      await simpleRobot.enterText("login-username", "kilianadmin");
      await simpleRobot.enterText("login-password", "mdp-kiki");
      await simpleRobot.tap("login-button");

      nbErrors += simpleRobot.nbErrors;
    });
  });

  group('[RESULTS]', () {
    testWidgets('Did tests passed ?', (WidgetTester tester) async {
      final log = logger(SimpleRobot);
      if (nbErrors == 0) {
        log.i("ALL TESTS PASSED!");
      } else {
        log.e("TESTS FAILED: " + nbErrors.toString());
      }
    });
  });
}


// await simpleRobot.tap("bottom-navbar-incident");
// await simpleRobot.tap("bottom-navbar-map");
// await simpleRobot.tap("bottom-navbar-incident");