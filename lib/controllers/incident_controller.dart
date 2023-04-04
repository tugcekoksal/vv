// Vendor
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/config/api_request.dart';
import 'package:velyvelo/config/caching_data.dart';
import 'package:velyvelo/config/url_to_file.dart';
import 'package:velyvelo/controllers/fetch_queue_controller.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/incident/incident_card_model.dart';

// Models
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/models/incident/incident_pieces.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/models/incident/refresh_incident_model.dart';
import 'package:velyvelo/models/json_usefull.dart';

// services
import 'package:velyvelo/services/http_service.dart';

class IncidentController extends GetxController {
  String userToken = "";

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // To implement
  // id of the first repair or null if first call
  // length of the incident list that I currently have or 0 if first call

  var isLoading = true.obs;
  var isLoadingDetailIncident = true.obs;

  List<IncidentPieces> listIncidentPieces = [];

  RxList<IncidentCardModel> incidentsList = <IncidentCardModel>[].obs;
  Rx<NbIncidents> nbIncidents = NbIncidents.empty().obs;

  var incidentFilters = <String>[].obs;

  var incidentDetailValue = IncidentDetailModel(
      groupe: "",
      velo: IdAndName(id: -1, name: ""),
      typeIncident: "",
      commentaire: "",
      photos: [],
      isFunctional: false,
      actualStatus: "",
      status: []).obs;

  var incidentsToFetch = RefreshIncidentModel(
          statusList: ["Terminé"],
          clientList: [],
          groupList: [],
          newestId: null,
          count: null)
      .obs;

  var groupListFilter = [].obs;

  var clientListFilter = [].obs;

  var currentImageIndexInViewer = 0.obs;

  var error = ''.obs;

  var currentIncidentId = 0.obs;

  var currentReparation = ReparationModel(
    statusBike: "",
    isBikeFunctional: true,
    incidentPk: 0,
    typeIntervention: IdAndName(id: 0, name: ""),
    typeReparation: IdAndName(id: 0, name: ""),
    cause: IdAndName(),
    causelist: [],
    reparationPhotosList: [],
    typeInterventionList: [],
    typeReparationList: [],
    piecesList: [],
    noPieces: false,
    selectedPieces: [],
    selectedPieceDropDown: IdAndName(id: 0, name: ""),
    commentaryTech: TextEditingController(),
    commentaryAdmin: TextEditingController(),
  ).obs;

  RxString actualTypeReparation = "".obs;
  RxList<String> dropDownItemIncidentTypeList = <String>[].obs;

  RxBool displaySearch = false.obs;
  RxString searchText = "".obs;
  final log = logger(IncidentController);

  @override
  void onInit() {
    userToken = Get.find<LoginController>().userToken;
    fetchAllIncidents(incidentsToFetch.value);
    fetchIncidentPieces();
    super.onInit();
  }

  Future<void> fetchIncidentFilters() async {
    try {
      var response = await HttpService.fetchIncidentFilters(userToken);
      clientListFilter.value = jsonListToIdAndNameList(response["client_list"]);
      groupListFilter.value = jsonListToIdAndNameList(response["group_list"]);
      groupListFilter.add(IdAndName(id: -1, name: "Pas de groupe"));
    } catch (e) {
      log.e(e.toString());
    }
    clientListFilter.refresh();
    groupListFilter.refresh();
    incidentsToFetch.refresh();
  }

  void setClientFilter(value, label) {
    IdAndName selected = clientListFilter.where((theGroup) {
      return theGroup.name == label;
    }).first;
    if (!value) {
      incidentsToFetch.value.clientList
          .removeWhere((selected) => selected.name == label);
    } else {
      if (!incidentsToFetch.value.clientList.contains(selected)) {
        incidentsToFetch.value.clientList.add(selected);
      }
    }
    incidentsToFetch.refresh();
  }

  void setGroupFilter(value, label) {
    IdAndName selected = groupListFilter.where((theClient) {
      return theClient.name == label;
    }).first;
    if (!value) {
      incidentsToFetch.value.groupList
          .removeWhere((selected) => selected.name == label);
    } else {
      if (!incidentsToFetch.value.groupList.contains(selected)) {
        incidentsToFetch.value.groupList.add(selected);
      }
    }
    incidentsToFetch.refresh();
  }

  void fetchIncidentTypeList() async {
    var incidentLabels = await HttpService.fetchIncidentLabels(userToken);
    dropDownItemIncidentTypeList.value =
        incidentLabels.map((e) => e.name ?? "Error incident label").toList();
    dropDownItemIncidentTypeList.refresh();
  }

  void setItemIncidentCause(value) {
    currentReparation.value.cause.name = value;
  }

  void setNoPieces(bool? value) {
    if (value != null) {
      currentReparation.update((reparation) {
        reparation!.noPieces = value;
      });
    }
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
        await HttpService.fetchIncident(incidentPk, userToken);
    infosReparation = jsonDecode(infosReparation);

    List<File> listPhotoFile = [];
    for (var photo in infosReparation["photos"]) {
      var photoFile = await urlToFile(HttpService.urlServer + photo);
      listPhotoFile.add(photoFile);
    }
    currentReparation.value =
        ReparationModel.fromJson(infosReparation, listPhotoFile);
    currentReparation.refresh();
    actualTypeReparation.value =
        currentReparation.value.typeReparation.name ?? "Error type reparation";
    fetchPieceFromType();
  }

  IdAndName getFirstWhereNameEqual(String name, List<IdAndName> list) {
    return list.firstWhere((elem) => elem.name == name,
        orElse: (() => IdAndName(id: -1, name: "")));
  }

  Future<void> fetchIncidentPieces() async {
    try {
      listIncidentPieces = await HttpService.fetchPieces(userToken);
      await writeIncidentPieces(listIncidentPieces);
    } catch (e) {
      log.e(e.toString());
    }
  }

  Future<void> fetchPieceFromType() async {
    try {
      List<IncidentPieces> incidentPieces = await readIncidentPieces();

      for (int i = 0; i < incidentPieces.length; i++) {
        if (incidentPieces[i].reparationId ==
            currentReparation.value.typeReparation.id) {
          currentReparation.update((reparation) {
            reparation!.piecesList = incidentPieces[i].pieces;
          });
        }
      }
    } catch (e) {
      log.e(e.toString());
    }
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

  // Observable getter
  RxBool get isIncidentListEmpty {
    return RxBool(nbIncidents.value.enCours == 0 &&
        nbIncidents.value.nouvelle == 0 &&
        nbIncidents.value.termine == 0);
  }

  Future<void> fetchAllIncidents(incidentsToFetch) async {
    isLoading.value = true;
    error.value = "";

    try {
      IncidentsModel incidentsModel = await HttpService.fetchAllIncidents(
          incidentsToFetch, searchText.value, userToken);

      incidentsList.value = incidentsModel.incidents;
      nbIncidents.value = incidentsModel.nbIncidents;

      // await writeListIncidents(incidentsModel);
      // Here we write the datas in a json file to keep them offline
    } catch (e) {
      try {
        // Here we use the datas in the json file that we previously stored for offline purposes
        // IncidentsModel incidentsModel = await readListIncidents();

        // incidentsList.value = incidentsModel.incidents;
        // nbIncidents.value = incidentsModel.nbIncidents;
      } catch (e) {
        // If there is nothing in the file we return an error
        log.e(e.toString());
        error.value =
            "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
      }
    }
    isLoading.value = false;
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
      log.e(e.toString());
    }
  }

  Future<bool> fetchNewIncidents() async {
    incidentsToFetch.value.newestId = int.parse(incidentsList.first.incidentPk);
    incidentsToFetch.value.count = incidentsList.length;

    incidentsToFetch.value.statusList =
        incidentFilters.isEmpty ? ["Terminé"] : incidentFilters;

    try {
      IncidentsModel incidents = await HttpService.fetchAllIncidents(
          incidentsToFetch.value, searchText.value, userToken);
      if (incidents.incidents.isNotEmpty) {
        incidentsList.value += incidents.incidents;
        return true;
      }
    } catch (e) {
      log.e(e.toString());
      error.value =
          "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
    return false;
  }

  Future<void> refreshIncidentsList() async {
    if (incidentFilters.isEmpty) {
      incidentsToFetch.value.statusList = ["Terminé"];
    } else {
      incidentsToFetch.value.statusList = incidentFilters;
    }
    await fetchAllIncidents(incidentsToFetch.value);
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
    if (currentReparation.value.cause.name == "Casse" &&
        currentReparation.value.reparationPhotosList.isEmpty) {
      error.value = "Si la cause est 'Casse' une photo est requise";
      return;
    }

    try {
      await HttpService.sendCurrentDetailBikeStatus(
          currentReparation.value, userToken);
    } on SocketException {
      try {
        failedRequestFunctions.add(() =>
            HttpService.sendCurrentDetailBikeStatus(
                currentReparation.value, userToken));
      } catch (e) {
        error.value = e.toString();
      }
    } catch (e) {
      error.value = e.toString();
    }
  }
}
