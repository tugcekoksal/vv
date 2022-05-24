// Vendor
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/my_app.dart';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//NOTIFS
import 'package:firebase_messaging/firebase_messaging.dart';

//NEW VERSION
import 'package:flutter/services.dart';

//SENTRY
import 'package:sentry_flutter/sentry_flutter.dart';

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

void main() async {
  // Always First
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://8c020d0b25804516a3f61ecad3ce0859@o916392.ingest.sentry.io/6417938';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );

  //FOR HTTP CALLS ANDROID
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Still no solutions to accept those terms with the test integration
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Allow IOS Notification when application is in foreground
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Run the App after all is well initialized
  // Don't show alert pop up authorize notification on integration test
  // (Can't click on native pop up with integration tests)

  // Auto logout user while testing
  final LoginController loginController = Get.put(LoginController());
  loginController.logoutUser();

  runApp(const MaterialApp(home: MyApp(showAlert: false)));
}
