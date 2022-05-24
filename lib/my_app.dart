import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

// Components
import 'package:velyvelo/screens/home/home_screen.dart';

//NEW VERSION
import 'package:new_version/new_version.dart';

class MyApp extends StatelessWidget {
  final bool showAlert;
  const MyApp({Key? key, this.showAlert = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showAlert) {
      final newVersion = NewVersion();
      newVersion.showAlertIfNecessary(context: context);
    }
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
      home: HomeScreen(),
    );
  }
}
