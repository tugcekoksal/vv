import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

// Components
import 'package:velyvelo/screens/home/home_screen.dart';
import 'package:upgrader/upgrader.dart';
import 'dart:io';

class MyApp extends StatefulWidget {
  final bool showAlert;
  const MyApp({super.key, this.showAlert = true});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('fr', '')],
      title: 'VelyVelo',
      theme: ThemeData(
        fontFamily: "Montserrat",
      ),
      home: UpgradeAlert(
          upgrader: Upgrader(
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            showLater: false,
            showIgnore: false,
          ),
          child: HomeScreen()),
    );
  }
}
