import 'package:flutter_test/flutter_test.dart';
import 'package:velyvelo/main_test.dart' as app;

Future<void> pumpApp(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();
}

int nbError = 0;
