// Vendor
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Components
import 'package:velyvelo/screens/home/home_screen.dart';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//NOTIFS
import 'package:firebase_messaging/firebase_messaging.dart';

//NEW VERSION
import 'package:new_version/new_version.dart';
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

// void main({bool testing = false}) async {
void main() async {
  // Logout user auto when testing
  // if (testing) {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
  prefs.remove("username");
  // }
  // Don t enable sentry on testing
  // if (testing == false) {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://8c020d0b25804516a3f61ecad3ce0859@o916392.ingest.sentry.io/6417938';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
  // }
  //FOR HTTP CALLS ANDROID
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Don t enable pop up notification authorization when testing
  // Still no solutions to accept those terms with the test integration suite
  // if (testing == false) {
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
  // }

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
  // if (testing) {
  // If we are testing, force app rebuild (to relog in same test group for ex)
  // runApp(MaterialApp(key: UniqueKey(), home: MyApp()));
  // } else {
  // Normal app launch
  runApp(MaterialApp(home: MyApp()));
  // }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newVersion = NewVersion();
    newVersion.showAlertIfNecessary(context: context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en', ''), const Locale('fr', '')],
      title: 'VelyVelo',
      theme: ThemeData(
        fontFamily: "Montserrat",
      ),
      home: HomeScreen(),
    );
  }
}
