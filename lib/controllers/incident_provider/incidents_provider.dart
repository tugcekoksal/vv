import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/incident/client_card_model.dart';
import 'package:velyvelo/models/incident/group_card_model.dart';
import 'package:velyvelo/models/incident/incident_card_model.dart';
import 'package:velyvelo/screens/views/incidents/components/group_card.dart';
import 'package:velyvelo/services/http_service.dart';

final incidentsProvider = ChangeNotifierProvider.autoDispose<IncidentsProvider>(
    (ref) => IncidentsProvider());

class IncidentsProvider extends ChangeNotifier {
  String userToken = "";
  View view = View.historicIncident;
  String title = "";

  LoginController loginController = Get.put(LoginController());

  // List clients
  List<ClientCardModel> clientCards = [];

  // List groups
  ClientCardModel selectedClient = ClientCardModel.empty();
  List<GroupCardModel> groupCards = [];

  // List reparations
  GroupCardModel selectedGroup = GroupCardModel.empty();
  List<IncidentCardModel> incidentCards = [];

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

  void selectClient(int index) {
    selectedClient = clientCards[index];
    view = View.listGroup;
    title = selectedClient.name;
    fetchListGroup();
    notifyListeners();
  }

  void fetchListGroup() async {
    try {
      groupCards =
          await HttpService.fetchGroupCards(selectedClient.id, userToken);
    } catch (e) {
      log.e(e.toString());
    }
    notifyListeners();
  }

  void selectGroup(int index) {
    selectedGroup = groupCards[index];
    view = View.listIncident;
    title = selectedGroup.name;
    fetchListReparation();
    notifyListeners();
  }

  void fetchListReparation() async {
    try {
      incidentCards = await HttpService.fetchIncidentCards(
          selectedGroup.id, selectedClient.id, userToken);
      print(incidentCards.length);
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
