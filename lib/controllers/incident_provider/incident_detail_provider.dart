import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velyvelo/helpers/usefull.dart';

final incidentDetailProvider =
    ChangeNotifierProvider.autoDispose<IncidentDetailProvider>(
        (ref) => IncidentDetailProvider());

class IncidentDetailProvider extends ChangeNotifier {
  String userToken = "";
  int indexImageInViewer = 0;
  String errorMsg = "";

  // Initialisation
  IncidentDetailProvider() {
    getTokenFromSharedPref().then((token) => {userToken = token});
  }
}
