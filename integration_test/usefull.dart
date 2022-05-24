import 'package:flutter_test/flutter_test.dart';
import 'package:velyvelo/main_test.dart' as app;

int nbError = 0;

Future<void> pumpApp(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();
}
