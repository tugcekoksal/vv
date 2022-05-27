# Try to manually launch emulator to be able to launch integration tests

echo "Shutting down all existing emulators..."
xcrun simctl shutdown all
echo "Recreating the emulator..."
xcrun simctl delete Iphone13 || echo Failed to delete Iphone13

# xcrun simctl list

# Usage: simctl create <name> <device type id> [<runtime id>]
xcrun simctl create Iphone13 com.apple.CoreSimulator.SimDeviceType.iPhone-13 com.apple.CoreSimulator.SimRuntime.iOS-15-2
echo "Booting..."
xcrun simctl boot Iphone13
echo "Checking boot status..."
xcrun simctl bootstatus Iphone13

echo "Running pub get..."
flutter pub get

echo "Running integration test..."
flutter test \
    integration_test/main_test.dart