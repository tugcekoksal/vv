
#!/bin/bash

set -e

echo "== Integration test app =="

# Grab packages.
flutter pub get

# Run the analyzer to find any static analysis issues.
# flutter analyze

# Run the formatter on all the dart files to make sure everything's linted.
# flutter format -n --set-exit-if-changed .

# Run the actual tests.
flutter test integration_test/main_test.dart