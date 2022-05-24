import 'package:flutter_test/flutter_test.dart';
import 'package:velyvelo/helpers/logger.dart';

import 'login/login_test.dart' as login_test;
import 'usefull.dart' as usefull;

final log = getLogger(WidgetTester);

void testResult() {
  group('[RESULTS]', () {
    testWidgets('Did tests passed ?', (WidgetTester tester) async {
      log.i("--- END OF TESTING ---");
      if (usefull.nbError != 0) {
        log.e("Errors encountered: " + usefull.nbError.toString());
      } else {
        log.i("All tests passed!");
      }
    });
  });
}

void main() {
  login_test.main();
  testResult();
}
