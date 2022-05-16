// Vendor
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/config/urlToFile.dart';

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
  // var incidentDetail;

  var nbOfNewIncidents = 0.obs;
  var nbOfProgressIncidents = 0.obs;
  var nbOfFinishedIncidents = 0.obs;

  var incidentFilters = <String>[].obs;

  var incidentDetailValue = IncidentDetailModel(
      groupe: "",
      velo: "",
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

  var currentIncidentId = 0.obs;

  var currentReparation = Reparation(
          statusBike: "",
          isBikeFunctional: true,
          incidentPk: 0,
          typeIntervention: IdAndName(id: 0, name: ""),
          typeReparation: IdAndName(id: 0, name: ""),
          reparationPhotosList: [],
          typeInterventionList: [],
          typeReparationList: [],
          piecesList: [],
          selectedPieces: [],
          selectedPieceDropDown: IdAndName(id: 0, name: ""),
          commentary: TextEditingController())
      .obs;

  RxString actualTypeReparation = "".obs;
  RxString selectedIncidentCause = "".obs;
  RxList<String> dropDownItemIncidentTypeList = <String>[].obs;

  // void fetchIncidentLabels() async {
  //   try {
  //     isLoadingLabelIncidentType(true);
  //     var incidentLabels = await HttpService.fetchIncidentLabels(userToken);
  //     if (incidentLabels != null) {
  //       incidentLabels.map((incidentLabel) {
  //         dropDownItemIncidentTypeList.add(incidentLabel);
  //       }).toList();
  //       dropDownItemIncidentTypeList.refresh();
  //     }
  //     isLoadingLabelIncidentType(false);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  void fetchIncidentTypeList() async {
    var incidentLabels = await HttpService.fetchIncidentLabels(userToken);
    dropDownItemIncidentTypeList.value =
        incidentLabels.map((e) => e.name).toList();
    dropDownItemIncidentTypeList.refresh();
  }

  void setItemIncidentCause(value, index) {
    selectedIncidentCause.value = value;
  }

  @override
  void onInit() {
    userToken = Get.find<LoginController>().userToken;
    fetchAllIncidents(incidentsToFetch.value);
    super.onInit();
  }

  void setReparationsPhotosValue(File imageTemporary) {
    currentReparation.update((reparation) {
      reparation!.reparationPhotosList.add(imageTemporary);
    });
  }

  void removePieceFromList(index) {
    currentReparation.update((reparation) {
      reparation!.selectedPieces.removeAt(index);
    });
  }

  Future<void> fetchReparation(String incidentPk) async {
    var infosReparation =
        await HttpService.fetchReparationByPk(incidentPk, userToken);
    infosReparation = jsonDecode(infosReparation);

    List<File> listPhotoFile = [];
    for (var photo in infosReparation["photos"]) {
      var photoFile = await urlToFile(HttpService.urlServer + photo);
      listPhotoFile.add(photoFile);
    }
    currentReparation.value = Reparation.fromJson(
        infosReparation, currentIncidentId.value, listPhotoFile);
    currentReparation.refresh();
    actualTypeReparation.value = currentReparation.value.typeReparation.name;
    fetchPieceFromType();
  }

  IdAndName getFirstWhereNameEqual(String name, List<IdAndName> list) {
    return list.firstWhere((elem) => elem.name == name,
        orElse: (() => IdAndName(id: -1, name: "")));
  }

  Future<void> fetchPieceFromType() async {
    // get selected intervention type
    IdAndName interventionType = currentReparation.value.typeIntervention;
    // get selected reparation type
    IdAndName reparationType = currentReparation.value.typeReparation;

    // ask the server for the relatives pieces from those filters
    var response = await HttpService.fetchPieceFromType(
        interventionType.id, reparationType.id, userToken);
    response = jsonDecode(response);
    var listPieces = jsonListToIdAndNameList(response["pieces"]);

    // update the list of availables pieces widget for selection
    currentReparation.update((reparation) {
      reparation!.piecesList = listPieces;
    });
  }

  setTypeIntervention(value) {
    currentReparation.update((reparation) {
      IdAndName typeIntervention = currentReparation.value.typeInterventionList
          .firstWhere((type) => type.name == value,
              orElse: (() => IdAndName(id: 0, name: "")));
      reparation!.typeIntervention = typeIntervention;
    });
    fetchPieceFromType();
  }

  setTypeReparation(value) {
    currentReparation.update((reparation) {
      IdAndName typeReparation = currentReparation.value.typeReparationList
          .firstWhere((type) => type.name == value,
              orElse: (() => IdAndName(id: 0, name: "")));
      reparation!.typeReparation = typeReparation;
    });
    fetchPieceFromType();
  }

  setPiece(value) {
    var piece = currentReparation.value.piecesList.firstWhere(
        (piece) => piece.name == value,
        orElse: (() => IdAndName(id: -1, name: "")));
    currentReparation.value.selectedPieceDropDown = piece;
  }

  addPiece() {
    if (currentReparation.value.selectedPieceDropDown.id != 0) {
      currentReparation.update((reparation) {
        reparation!.selectedPieces.insert(0, reparation.selectedPieceDropDown);
      });
    }
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
        noIncidentsToShow(true);
      }
      error.value = "";
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
        currentReparation.value.isBikeFunctional = incidentByID.isFunctional;
        currentReparation.value.statusBike = incidentByID.actualStatus;
      }
      isLoadingDetailIncident(false);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchNewIncidents() async {
    final RefreshIncidentModel incidentsToFetchFilter = RefreshIncidentModel(
        statusList: incidentFilters,
        newestId: int.parse(incidentList.first.incidentPk),
        count: incidentList.length);

    if (incidentFilters.length == 0) {
      incidentsToFetchFilter.statusList = ["Nouvelle", "En cours", "Terminé"];
    }
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
    final RefreshIncidentModel incidentsToFetchFilter;

    if (incidentFilters.length == 0) {
      incidentsToFetchFilter =
          RefreshIncidentModel(statusList: ["Nouvelle", "En cours", "Terminé"]);
    } else {
      incidentsToFetchFilter =
          RefreshIncidentModel(statusList: incidentFilters);
    }
    await fetchAllIncidents(incidentsToFetchFilter);
  }

  setStatusToDisplay(filter) async {
    if (incidentFilters.contains(filter)) {
      incidentFilters.removeWhere((filterElement) => filterElement == filter);
    } else {
      incidentFilters.add(filter);
    }

    refreshIncidentsList();
  }

  setCurrentDetailBikeStatus(value) async {
    currentReparation.update((reparation) {
      reparation!.isBikeFunctional = value;
    });
  }

  setBikeStatus(value) async {
    currentReparation.update((reparation) {
      reparation!.statusBike = value;
    });
  }

  sendReparationUpdate() async {
    error.value = "";

    try {
      await HttpService.sendCurrentDetailBikeStatus(
          currentReparation.value, selectedIncidentCause.value, userToken);
    } catch (e) {
      error.value = e.toString();
      print(error.value);
    }
    fetchReparation(currentIncidentId.value.toString());
  }
}
