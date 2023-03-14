import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/incident/client_card_model.dart';
import 'package:velyvelo/services/http_service.dart';

final incidentsProvider = ChangeNotifierProvider.autoDispose<IncidentsProvider>(
    (ref) => IncidentsProvider());

class IncidentsProvider extends ChangeNotifier {
  String userToken = "";
  View view = View.historicIncident;
  String title = "";

  LoginController loginController = Get.put(LoginController());

  List<ClientCardModel> clientCards = [];

  final log = logger(IncidentsProvider);

  // Initialisation
  IncidentsProvider() {
    getTokenFromSharedPref().then((token) {
      userToken = token;
      fetchListClient();
    });
    title = titlePage[view]!;
  }

  void swapView(View newView) {
    view = newView;
    title = titlePage[view]!;
    notifyListeners();
  }

  void fetchListClient() async {
    try {
      clientCards = await HttpService.fetchClientCards(userToken);
    } catch (e) {
      log.e(e.toString());
    }
    notifyListeners();
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
