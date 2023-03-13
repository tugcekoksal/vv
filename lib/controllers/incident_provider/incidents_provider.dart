import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velyvelo/helpers/usefull.dart';

final incidentsProvider = ChangeNotifierProvider.autoDispose<IncidentsProvider>(
    (ref) => IncidentsProvider());

class IncidentsProvider extends ChangeNotifier {
  String userToken = "";
  View view = View.historicIncident;
  String title = "";

  // Initialisation
  IncidentsProvider() {
    getTokenFromSharedPref().then((token) => {userToken = token});
    title = titlePage[view]!;
  }

  void swapView(View newView) {
    view = newView;
    title = titlePage[view]!;
    notifyListeners();
  }

  void fetchListClient() {
    
  }
}

const Map<View, String> titlePage = {
  View.listClient: "Incidents",
  View.historicIncident: "Historique"
};

enum View {
  listClient,
  listGroup,
  listIncident,
  historicIncident,
}
