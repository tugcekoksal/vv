import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:velyvelo/config/caching_data.dart';
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
  View view = View.listClient;
  String title = "";
  String error = "";

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
    initCacheFiles();
    getTokenFromSharedPref().then((token) {
      userToken = token;
      fetchListClient();
    });
    title = titlePage[view]!;
  }

  void resetData() {
    // List groups
    selectedClient = ClientCardModel.empty();
    groupCards = [];

    // List reparations
    selectedGroup = GroupCardModel.empty();
    incidentCards = [];
  }

  void swapView(View newView) {
    view = newView;
    title = titlePage[view]!;
    resetData();
    notifyListeners();
    fetchListClient();
  }

  Future fetchListClient() async {
    error = "";
    try {
      clientCards = await HttpService.fetchClientCards(userToken);
      await writeListClientIncidents(clientCards);
    } catch (e) {
      try {
        clientCards = await readListClientIncidents();
      } catch (e) {
        log.e(e.toString());
        error = "Erreur chargement des données clients";
      }
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

  Future fetchListGroup() async {
    error = "";
    try {
      groupCards =
          await HttpService.fetchGroupCards(selectedClient.id, userToken);
      await writeListGroupIncidents(groupCards, selectedClient.id);
    } catch (e) {
      try {
        groupCards = await readListGroupIncidents(selectedClient.id);
      } catch (e) {
        log.e(e.toString());
        error = "Erreur chargement des données groupes clients";
      }
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

  Future fetchListReparation() async {
    error = "";
    try {
      incidentCards = await HttpService.fetchIncidentCards(
          selectedGroup.id, selectedClient.id, userToken);
      await writeListIncidents(incidentCards, selectedGroup.id);
    } catch (e) {
      try {
        incidentCards = await readListIncidents(selectedGroup.id);
      } catch (e) {
        log.e(e.toString());
        error = "Erreur chargement des données incidents";
      }
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
