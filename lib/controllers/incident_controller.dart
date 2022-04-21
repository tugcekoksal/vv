// Vendor
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/config/urlToFile.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/utf8_convert.dart';

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

  var currentIncidentId = 0.obs;

  var currentReparation = Reparation(
          statusBike: "",
          isBikeFunctional: true,
          incidentPk: 0,
          reparationPhotosList: [],
          typeInterventionList: [],
          typeReparationList: [],
          valueTypeIntervention: "",
          valueTypeReparation: "",
          piecesList: [],
          selectedPieces: [],
          selectedPieceDropDown: IdAndName(id: 0, name: ""),
          commentary: TextEditingController())
      .obs;

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

  Future<void> fetchReparation(incidentPk) async {
    print("FETCH");
    var infosReparation =
        await HttpService.fetchReparationByPk(incidentPk, userToken);
    infosReparation = jsonDecode(infosReparation);

    List<File> listPhotoFile = [];
    for (var photo in infosReparation["photos"]) {
      var photoFile = await urlToFile(HttpService.urlServer + photo);
      listPhotoFile.add(photoFile);
    }

    print(infosReparation["commentary"]);
    currentReparation.value = Reparation(
        statusBike: infosReparation["status_bike"],
        isBikeFunctional: infosReparation["is_bike_functional"],
        incidentPk: currentIncidentId.value,
        reparationPhotosList: listPhotoFile,
        typeInterventionList:
            jsonListToIdAndNameList(infosReparation["list_type_intervention"]),
        typeReparationList:
            jsonListToIdAndNameList(infosReparation["list_type_reparation"]),
        valueTypeIntervention: "",
        valueTypeReparation: "",
        piecesList: [],
        selectedPieces: jsonListToIdAndNameList(infosReparation["pieces"]),
        selectedPieceDropDown: IdAndName(id: 0, name: ""),
        commentary: TextEditingController(
            text: infosReparation["commentary"])); // changer ici
    print(currentReparation.value.selectedPieces[0].name);
  }

  IdAndName getFirstWhereNameEqual(String name, List<IdAndName> list) {
    return list.firstWhere((elem) => utf8convert(elem.name) == name,
        orElse: (() => IdAndName(id: -1, name: "")));
  }

  Future<void> fetchPieceFromType() async {
    // get selected intervention type
    var interventionType = getFirstWhereNameEqual(
        currentReparation.value.valueTypeIntervention,
        currentReparation.value.typeInterventionList);
    // get selected reparation type
    var reparationType = getFirstWhereNameEqual(
        currentReparation.value.valueTypeReparation,
        currentReparation.value.typeReparationList);

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
      reparation!.valueTypeIntervention = value;
    });
    fetchPieceFromType();
  }

  setTypeReparation(value) {
    currentReparation.update((reparation) {
      reparation!.valueTypeReparation = value;
    });
    fetchPieceFromType();
  }

  setPiece(value) {
    var piece = currentReparation.value.piecesList.firstWhere(
        (piece) => utf8convert(piece.name) == value,
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

    refreshIncidentsList();
  }

  setCurrentDetailBikeStatus(value) async {
    currentReparation.update((reparation) {
      reparation!.isBikeFunctional = value;
    });
    print(currentReparation.value.isBikeFunctional);
  }

  setBikeStatus(value) async {
    currentReparation.update((reparation) {
      reparation!.statusBike = value;
    });
    print(currentReparation.value.statusBike);
  }

  sendReparationUpdate() async {
    try {
      await HttpService.sendCurrentDetailBikeStatus(
          currentReparation.value, userToken);
    } catch (e) {
      print("error send state1 $e");
    }
  }
}
