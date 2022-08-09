import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

// Components
import 'package:velyvelo/screens/home/home_screen.dart';

//NEW VERSION
import 'package:new_version/new_version.dart';

class MyApp extends StatefulWidget {
  final bool showAlert;
  const MyApp({Key? key, this.showAlert = true}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    if (widget.showAlert) {
      advancedStatusCheck(NewVersion newVersion) async {
        final status = await newVersion.getVersionStatus();
        if (status != null) {
          debugPrint(status.releaseNotes);
          debugPrint(status.appStoreLink);
          debugPrint(status.localVersion);
          debugPrint(status.storeVersion);
          debugPrint(status.canUpdate.toString());
          newVersion.showUpdateDialog(
            context: context,
            versionStatus: status,
            dialogTitle: 'Mise à jour',
            dialogText: 'Une mise à jour est disponible',
          );
        }
      }

      @override
      void initState() {
        super.initState();

        // Instantiate NewVersion manager object (Using GCP Console app as example)
        final newVersion = NewVersion(
          iOSId: 'com.grafenit.velyvelo',
          androidId: 'com.grafenit.velyvelo',
        );

        // You can let the plugin handle fetching the status and showing a dialog,
        // or you can fetch the status and display your own dialog, or no dialog.

        advancedStatusCheck(newVersion);
      }
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
