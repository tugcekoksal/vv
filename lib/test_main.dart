// Vendor
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/main.dart';
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
  // Common test and normal launch setup
  await commonSetUp();

  // Auto logout user while testing
  final LoginController loginController = Get.put(LoginController());
  loginController.logoutUser();

  // Run the App after all is well initialized
  // Don't show alert pop up authorize notification on integration test
  // (Can't click on native pop up with integration tests)
  runApp(
      const ProviderScope(child: MaterialApp(home: MyApp(showAlert: false))));
}
