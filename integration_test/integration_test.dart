import 'package:flutter_test/flutter_test.dart';
import 'package:velyvelo/helpers/logger.dart';

import 'integration/init/init_test.dart' as init_test;
import 'integration/login/login_test.dart' as login_test;
import 'integration/usefull.dart' as usefull;

final log = logger(WidgetTester);

void testResult() {
  group('[RESULTS]', () {
    testWidgets('Did tests passed ?', (WidgetTester tester) async {
      log.i("--- END OF TESTING ---");
      if (usefull.nbError != 0) {
        log.e("Errors encountered: " + usefull.nbError.toString());
        throw ("Errors encountered: " + usefull.nbError.toString());
      } else {
        log.i("All tests passed!");
      }
    });
  });
}

void main() {
  init_test.main();
  login_test.main();
  testResult();
}
