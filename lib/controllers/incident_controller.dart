// Vendor
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

// Models
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/models/incident/refresh_incident_model.dart';

// services
import 'package:velyvelo/services/http_service.dart';

class IncidentController extends GetxController {
  var userToken;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // To implement
  // id of the first repair or null if first call
  // length of the incident list that I currently have or 0 if first call

  var isLoading = true.obs;
  var noIncidentsToShow = false.obs;
  var isLoadingDetailIncident = true.obs;

  var incidentList = <Incident>[].obs;
  var incidentDetail;

  var nbOfNewIncidents = 0.obs;
  var nbOfProgressIncidents = 0.obs;
  var nbOfFinishedIncidents = 0.obs;

  var incidentFilters = ["Nouvelle", "En cours", "Terminé"].obs;

  var incidentDetailValue = IncidentDetailModel(
      groupe: "",
      velo: "",
      batteries: "",
      typeIncident: "",
      commentaire: "",
      photos: [],
      isFunctional: false,
      actualStatus: "",
      status: []).obs;

  var incidentsToFetch = RefreshIncidentModel(
          statusList: ["Nouvelle", "En cours", "Terminé"],
          newestId: null,
          count: null)
      .obs;

  var currentImageIndexInViewer = 0.obs;

  var error = ''.obs;

  var currentStatusBike = ''.obs;
  var isBikeFunctional = false.obs;
  var currentBikeId = 0.obs;

  @override
  void onInit() {
    userToken = Get.find<LoginController>().userToken;
    fetchAllIncidents(incidentsToFetch.value);
    super.onInit();
  }

  Future<void> fetchAllIncidents(incidentsToFetch) async {
    noIncidentsToShow(false);
    try {
      isLoading(true);
      var incidents =
          await HttpService.fetchAllIncidents(incidentsToFetch, userToken);
      if (incidents != null && incidents.incidents.length != 0) {
        incidentList.value = incidents.incidents;
        nbOfNewIncidents.value = incidents.nbIncidents.nouvelle;
        nbOfProgressIncidents.value = incidents.nbIncidents.enCours;
        nbOfFinishedIncidents.value = incidents.nbIncidents.termine;

        isLoading(false);
      } else if (incidents.incidents.length == 0) {
        isLoading(false);
        print("There's no incidents to show");
        noIncidentsToShow(true);
      }
    } catch (e) {
      isLoading(false);
      print("error incident $e");
      error.value =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
  }

  Future<void> fetchIncidentById(int id) async {
    try {
      isLoadingDetailIncident(true);
      var incidentByID = await HttpService.fetchIncidentById(id, userToken);
      if (incidentByID != null) {
        incidentDetailValue.value = incidentByID;
        isBikeFunctional.value = incidentByID.isFunctional;
        currentStatusBike.value = incidentByID.actualStatus;
        print(incidentByID);
      }
      isLoadingDetailIncident(false);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchNewIncidents() async {
    final RefreshIncidentModel incidentsToFetchFilter = RefreshIncidentModel(
        statusList: incidentFilters,
        newestId: int.parse(incidentList.first.incidentPk!),
        count: incidentList.length);

    try {
      var incidents = await HttpService.fetchAllIncidents(
          incidentsToFetchFilter, userToken);
      if (incidents != null && incidents.incidents.length != 0) {
        incidentList = incidentList + incidents.incidents;
      }
    } catch (e) {
      print("error incident $e");
      error.value =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
  }

  Future<void> refreshIncidentsList() async {
    final RefreshIncidentModel incidentsToFetchFilter =
        RefreshIncidentModel(statusList: incidentFilters);

    await fetchAllIncidents(incidentsToFetchFilter);
  }

  setStatusToDisplay(filter) async {
    if (incidentFilters.contains(filter)) {
      incidentFilters.removeWhere((filterElement) => filterElement == filter);
    } else {
      incidentFilters.add(filter);
    }

    print(incidentFilters);

    refreshIncidentsList();
  }

  setCurrentDetailBikeStatus(value) async {
    isBikeFunctional.value = value;

    try {
      await HttpService.sendCurrentDetailBikeStatus(currentBikeId.value,
          isBikeFunctional.value, currentStatusBike.value, userToken);
    } catch (e) {
      print("error send state $e");
    }
    print(isBikeFunctional.value);
  }

  setBikeStatus(value) async {
    currentStatusBike.value = value;
    try {
      await HttpService.sendCurrentDetailBikeStatus(currentBikeId.value,
          isBikeFunctional.value, currentStatusBike.value, userToken);
    } catch (e) {
      print("error send state1 $e");
    }
    print(currentStatusBike.value);
  }

  destroy() {
    currentStatusBike.value = "";
    currentBikeId.value = 0;
  }
}
