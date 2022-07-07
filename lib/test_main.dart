// Vendor
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/main.dart';
import 'package:velyvelo/my_app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
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
