import 'package:flutter_test/flutter_test.dart';

// ignore: avoid_relative_lib_imports
import '../../../lib/helpers/logger.dart';
import 'simple_robot.dart';

class LoginRobot {
  final WidgetTester tester;
  final log = logger(LoginRobot, isColored: true);
  final SimpleRobot simpleRobot;

  LoginRobot(this.tester) : simpleRobot = SimpleRobot(tester);

  Future<void> login(String username, String password) async {
    await simpleRobot.enterText("login-username", username);
    await simpleRobot.enterText("login-password", password);
    await simpleRobot.tap("login-button");
  }

  Future<void> isNotLogged(String expectedError) async {
    await simpleRobot.expectText(expectedError);
  }

  Future<void> isLogged() async {
    await simpleRobot.expectText("Incidents", occurences: 2);
  }
}
