import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../robots/login_robot.dart';
import '../usefull.dart';

void testErrorLogin() {
  group('[Test error login]', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Error missing username', (WidgetTester tester) async {
      LoginRobot loginRobot = LoginRobot(tester);
      await pumpApp(tester);

      await loginRobot.login("", "");
      await loginRobot.isNotLogged("Le champ identifiant ne peut être vide");
    });

    testWidgets('Error missing password', (WidgetTester tester) async {
      LoginRobot loginRobot = LoginRobot(tester);
      await pumpApp(tester);

      await loginRobot.login("kilianadmin", "");
      await loginRobot.isNotLogged("Le champ mot de passe ne peut être vide");
    });

    testWidgets('Error bad informations', (WidgetTester tester) async {
      LoginRobot loginRobot = LoginRobot(tester);
      await pumpApp(tester);

      await loginRobot.login("username", "e");
      await loginRobot.isNotLogged("Les informations fournies sont invalides");
    });
  });
}

void testValidLogin() {
  group('[Test valid login]', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Valid login', (WidgetTester tester) async {
      LoginRobot loginRobot = LoginRobot(tester);
      await pumpApp(tester);

      await loginRobot.login("kilianadmin", "mdp-kiki");
      await loginRobot.isLogged();
    });
  });
}

void main() {
  testErrorLogin();
  testValidLogin();
  testErrorLogin();
}
