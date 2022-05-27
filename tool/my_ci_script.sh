# Set permissions for emulator to bypass ios pop up blocking integration test

echo "Shutting down all existing emulators..."
xcrun simctl shutdown all
echo "Recreating the emulator..."
xcrun simctl delete iOS13TestDevice || echo Failed to delete iOS13TestDevice

# Usage: simctl create <name> <device type id> [<runtime id>]
xcrun simctl create iOS13TestDevice com.apple.CoreSimulator.SimDeviceType.iPhone-SE-3rd-generation com.apple.CoreSimulator.SimRuntime.iOS-15-5
echo "Booting..."
xcrun simctl boot iOS13TestDevice
echo "Checking boot status..."
xcrun simctl bootstatus iOS13TestDevice

echo "Running pub get..."
flutter pub get

echo "Running integration test..."
flutter test \
    integration_test/main_test.dart