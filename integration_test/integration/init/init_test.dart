import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../usefull.dart';

void main() {
  group('[INIT APP TESTS]', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Wait for app to settle...', (WidgetTester tester) async {
      await pumpApp(tester);
    });
  });
}