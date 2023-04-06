// Vendor
import 'dart:io';
import 'package:get/get.dart';
import 'package:velyvelo/config/api_request.dart';
import 'package:velyvelo/config/storage_util.dart';
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/helpers/logger.dart';

// Models
import 'package:velyvelo/models/incident/incident_to_send_model.dart';
import 'package:velyvelo/models/json_usefull.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

// Models

class DeclarationInfoContainer {
  final IdAndName? client;
  final IdAndName? group;
  final IdAndName? velo;

  DeclarationInfoContainer({this.client, this.group, this.velo});
}

class DeclarationInfoDropDown {
  List<IdAndName> listOptions;
  bool isLoading;
  IdAndName? selected;

  DeclarationInfoDropDown(
      {required this.listOptions, required this.isLoading, this.selected});
}

class DeclarationInfoSelection {
  final DeclarationInfoDropDown infoClient;
  final DeclarationInfoDropDown infoGroup;
  final DeclarationInfoDropDown infoVelo;

  DeclarationInfoSelection(
      {required this.infoClient,
      required this.infoGroup,
      required this.infoVelo});
}

class DeclarationErrors {
  String veloError;

  DeclarationErrors({required this.veloError});
}

DeclarationInfoSelection emptySelection() {
  return DeclarationInfoSelection(
      infoClient: DeclarationInfoDropDown(
          listOptions: [], isLoading: true, selected: null),
      infoGroup: DeclarationInfoDropDown(
          listOptions: [], isLoading: true, selected: null),
      infoVelo: DeclarationInfoDropDown(
          listOptions: [], isLoading: true, selected: null));
}

class IncidentDeclarationController extends GetxController {
  // User infos
  String userToken = "";
  String userType = "";

  // Generic infos
  Rx<DeclarationInfoSelection> infosSelection = emptySelection().obs;
  Rx<DeclarationInfoDropDown> incidentTypeSelection =
      DeclarationInfoDropDown(listOptions: [], isLoading: true).obs;

  // Technician
  Rx<bool> selfAttribute = false.obs;

  // Errors
  Rx<DeclarationErrors> errors = DeclarationErrors(veloError: "").obs;

  // Old part for list incident declaration list

  var currentImageIndexInViewer = 0.obs;

  var index = 1;

  // List of forms, there's 1 by default
  var incidentMoreFormsList = [].obs;

  // List of indidents to send
  var incidentTypeList = [""].obs;
  var incidentCommentList = [""].obs;
  var incidentPhotosList = <List<File>>[[]].obs;

  var isFormUncompleted = "".obs;
  var indexWhereFormIsNotCompleted = "".obs;
  var veloFormNotCompleted = "".obs;
  var success = "".obs;

  final log = logger(IncidentController);

  @override
  void onInit() {
    userToken = Get.find<LoginController>().userToken;
    userType = Get.find<LoginController>().userType;
    // Never change so we can initialize at beginning
    fetchIncidentLabels();
    super.onInit();
  }

  void resetGroupDropDown() {
    infosSelection.update((val) {
      val?.infoGroup.listOptions = [];
      val?.infoGroup.selected = null;
    });
  }

  void resetVeloDropDown() {
    infosSelection.update((val) {
      val?.infoVelo.listOptions = [];
      val?.infoVelo.selected = null;
    });
  }

  // Client DropDown - BEGIN //
  void fetchClientLabels() async {
    // Client labels are loading
    infosSelection.update((val) {
      val?.infoClient.isLoading = true;
    });
    List<IdAndName> clientLabels = [];
    try {
      clientLabels = await HttpService.fetchClientLabelsByUser(userToken);
      await StorageUtil.saveIdAndNameList(
          "clientLabels", clientLabels); // save client IDs to local
    } on SocketException {
      clientLabels = StorageUtil.loadIdAndNameList("clientLabels");
    } catch (e) {
      log.e(e.toString());
      // Message error from server / handle front error
    }
    try {
      // Data received / valid request to server
      if (userType != "AdminOrTechnician" && userType != "Technicien") {
        infosSelection.update((val) {
          val?.infoClient.selected = clientLabels[0];
        });
        // Simulate the selection of client
        infosSelection.update((val) {
          val?.infoClient.selected = infosSelection.value.infoClient.selected;
          val?.infoClient.isLoading = false;
        });
        fetchGroupLabels();
        return;
        // End simulation and return
      }
    } catch (e) {
      log.e(e.toString());
    }

    infosSelection.update((val) {
      val?.infoClient.listOptions = clientLabels;
    });

    // Client labels finished loading
    infosSelection.update((val) {
      val?.infoClient.isLoading = false;
    });
  }

  void setClientLabel(String value) {
    // Find the IdAndName object from name value ine the listOptions
    IdAndName selected = infosSelection.value.infoClient.listOptions.firstWhere(
      (element) {
        return element.name == value;
      },
    );
    // Update the current selected label
    infosSelection.update((val) {
      val?.infoClient.selected = selected;
    });

    // Reinitialisation Velo and Group options
    resetGroupDropDown();
    resetVeloDropDown();
    // Now we have a client we can pick a group
    fetchGroupLabels();
  }
  // Client DropDown - END //

  // Group DropDown - BEGIN //
  void fetchGroupLabels() async {
    // Only called when the setClientLabel function is call
    infosSelection.update((val) {
      val?.infoGroup.isLoading = true;
    });
    List<IdAndName> groupLabels = [];
    try {
      groupLabels = await HttpService.fetchGroupLabelsByClient(
          infosSelection.value.infoClient.selected!.id ?? -1, userToken);
      await StorageUtil.saveIdAndNameList("groupLabels", groupLabels);
    } on SocketException {
      groupLabels = StorageUtil.loadIdAndNameList("groupLabels");
    } catch (e) {
      log.e(e.toString());
    }
    try {
      if (userType == "User") {
        infosSelection.update((val) {
          val?.infoGroup.selected = groupLabels[0];
        });
        // Simulate the selection of client
        infosSelection.update((val) {
          val?.infoGroup.selected = infosSelection.value.infoGroup.selected;
        });
        fetchVeloLabels();
        return;
        // End simulation and return
      }
      groupLabels.insert(0, IdAndName(id: -1, name: "Sans groupe"));
      // Data received / valid request to server
      infosSelection.update((val) {
        val?.infoGroup.listOptions = groupLabels;
      });
    } catch (e) {
      log.e(e.toString());
    }

    // Client labels finished loading
    infosSelection.update((val) {
      val?.infoGroup.isLoading = false;
    });
  }

  void setGroupLabel(String value) {
    // Find the IdAndName object from name value ine the listOptions
    IdAndName selected = infosSelection.value.infoGroup.listOptions.firstWhere(
      (element) {
        return element.name == value;
      },
    );
    // Update the current selected label
    infosSelection.update((val) {
      val?.infoGroup.selected = selected;
    });
    // Reset velo selection datas
    resetVeloDropDown();
    // Now we have a group we can pick a velo
    fetchVeloLabels();
  }
  // Group DropDown - END //

  // Velo DropDown - BEGIN //
  void fetchVeloLabels() async {
    // Only called when the setClientLabel function is call
    infosSelection.update((val) {
      val?.infoVelo.isLoading = true;
    });
    try {
      Map<String, List<IdAndName>> equipementsLabels =
          await HttpService.fetchBikeLabelsByGroup(
              infosSelection.value.infoGroup.selected!.id ?? -1,
              infosSelection.value.infoClient.selected!.id ?? -1,
              userToken);

      // Data received / valid request to server
      infosSelection.update((val) {
        val?.infoVelo.listOptions = [];
        val?.infoVelo.listOptions += equipementsLabels["velos"] ?? [];
        val?.infoVelo.listOptions += equipementsLabels["batteries"] ?? [];
      });
    } catch (e) {
      log.e(e.toString());
      // Message error from server / handle front error
    }

    // Client labels finished loading
    infosSelection.update((val) {
      val?.infoVelo.isLoading = false;
    });
  }

  void setVeloLabel(String value) {
    // Find the IdAndName object from name value ine the listOptions
    IdAndName selected = infosSelection.value.infoVelo.listOptions.firstWhere(
      (element) {
        return element.name == value;
      },
    );
    // Update the current selected label
    infosSelection.update((val) {
      val?.infoVelo.selected = selected;
    });
    // Now we have a velo we can keep going declaring incident
  }
  // Velo DropDown - END //

  // Incident DropDown - BEGIN //
  void fetchIncidentLabels() async {
    incidentTypeSelection.update((val) {
      val?.isLoading = true;
    });
    incidentTypeSelection.value.isLoading = true;
    try {
      List<IdAndName> incidentLabels =
          await HttpService.fetchIncidentLabels(userToken);
      incidentTypeSelection.update((val) {
        val?.listOptions = incidentLabels;
      });
    } catch (e) {
      log.e(e.toString());
    }
    incidentTypeSelection.update((val) {
      val?.isLoading = false;
    });
  }

  // set the value of each incident TYPE in the state;
  setIncidentTypeLabel(value, index) {
    incidentTypeList[index] = value;

    if (index.toString() == indexWhereFormIsNotCompleted.value) {
      indexWhereFormIsNotCompleted.value = "";
    }
  }
  // Incident DropDown - END //

  // Old part for list incident declaration list

  // Add a new form of incident declaration
  addForm() {
    incidentMoreFormsList.add(index);
    incidentTypeList.add("");
    incidentCommentList.add("");
    incidentPhotosList.add([]);
    index++;
  }

  // Delete a form
  deleteForm(indexToDelete) {
    // Can be updated in the future to delete a specific form
    // Removing the last item
    incidentTypeList.removeLast();
    incidentCommentList.removeLast();
    incidentPhotosList.removeLast();
    incidentMoreFormsList.removeLast();

    index--;
  }

  // set the value of each incident COMMENT in the state;
  setIncidentCommentValue(value, index) {
    incidentCommentList[index] = value;
  }

  // set the value of each incident PHOTOS in the state;
  setIncidentPhotosValue(value, index) {
    incidentPhotosList[index].add(value);
    incidentPhotosList.refresh();
  }

  // Send the incident to the server if
  Future<bool> sendIncident(int? veloPkFromScan) async {
    isFormUncompleted.value = "";
    success.value = "";

    // Check if informations are complete
    if (incidentTypeList.contains("")) {
      indexWhereFormIsNotCompleted.value =
          incidentTypeList.indexWhere((element) => (element == "")).toString();
      isFormUncompleted.value = "Un champ n'est pas spécifié.";
      return false;
    } else {
      indexWhereFormIsNotCompleted.value = "";
    }

    List<int> incidentFormAllList = List.from(incidentMoreFormsList);
    // Add an index form to add the first form that is not optional
    incidentFormAllList.insert(0, 0);

    List<IncidentToSendModel> incidentsToSend = [];

    // Loop threw all the incidents
    int veloPk;
    if (veloPkFromScan != null) {
      veloPk = veloPkFromScan;
    } else {
      if (userType == "user") {
        veloPk = Get.find<LoginController>().userBikeID.value;
      } else {
        veloPk = infosSelection.value.infoVelo.selected!.id ?? -1;
      }
    }

    for (var index in incidentFormAllList) {
      IncidentToSendModel incident = IncidentToSendModel(
          veloPk: veloPk.toString(),
          type: incidentTypeList[index],
          commentary: incidentCommentList[index],
          files: incidentPhotosList[index],
          isSelfAttributed: selfAttribute.value);
      incidentsToSend.add(incident);
    }

    // Send all the incidents
    incidentsToSend.map((incidentToSend) async {
      try {
        String incidentSent =
            await HttpService.setIncident(incidentToSend, userToken);
        success.value = incidentSent;
        Get.find<IncidentController>().refreshIncidentsList();
      } on SocketException {
        try {
          failedRequestFunctions
              .add(() => HttpService.setIncident(incidentToSend, userToken));
        } catch (e) {
          log.e(e.toString());
          return false;
        }
      } catch (e) {
        log.e(e.toString());
        return false;
      }
      return false;
    }).toList();
    return true;
  }

  // Delete all forms
  deleteAllForms() {
    // Clear the additional forms
    incidentMoreFormsList.clear();

    // Clear the types of those forms
    incidentTypeList.clear();
    incidentTypeList.add("");

    // Clear the comments of those forms
    incidentCommentList.clear();
    incidentCommentList.add("");

    // Clear te photos of those forms
    incidentPhotosList.clear();
    incidentPhotosList.add([]);

    index = 1;
  }
}
