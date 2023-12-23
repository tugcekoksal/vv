// Vendor
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velyvelo/config/storage_util.dart';
import 'package:velyvelo/my_app.dart';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//NOTIFS
import 'package:firebase_messaging/firebase_messaging.dart';

//NEW VERSION
import 'package:flutter/services.dart';

//FOR HTTP CALLS ANDROID
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

Future<void> commonSetUp() async {
  // Always first
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //FOR HTTP CALLS ANDROID
  HttpOverrides.global = MyHttpOverrides();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Allow IOS Notification when application is in foreground
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

// void main({bool testing = false}) async {
void main() async {
  // Common test and normal launch setup
  await commonSetUp();

  // Still no solutions to accept those terms with the test integration suite
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await StorageUtil
      .init(); // initialisation SharePreferences pour le stockage en local

  // Run the App after all is well initialized
  // Normal app launch
  runApp(const ProviderScope(child: MaterialApp(home: MyApp())));
}
