// Vendor
import 'dart:io';
import 'package:get/get.dart';
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/controllers/login_controller.dart';

// Models
import 'package:velyvelo/models/incident/incident_to_send_model.dart';

// Services
import 'package:velyvelo/services/http_service.dart';

class IncidentDeclarationController extends GetxController {
  var userToken;
  var userType;

  var currentImageIndexInViewer = 0.obs;

  var isLoadingLabelClient = true.obs;
  var isLoadingLabelGroup = true.obs;
  var isLoadingLabelBike = true.obs;
  var isLoadingLabelIncidentType = true.obs;

  var labelList = [].obs;
  var informations =
      {"Client": "", "Groupe": "", "Vélo": "", "Batterie": ""}.obs;

  var clientLabelPicked = false.obs;
  var groupLabelPicked = false.obs;
  var bikeLabelPicked = false.obs;

  var index = 1;

  // List of forms, there's 1 by default
  var incidentMoreFormsList = [].obs;

  // List of indidents to send
  var incidentTypeList = [""].obs;
  var incidentCommentList = [""].obs;
  var incidentPhotosList = <List<File>>[[]].obs;

  var dropdownItemClientList = [].obs;
  var dropdownItemClientListNames = <String>[].obs;

  var dropdownItemGroupList = [].obs;
  var dropdownItemGroupListNames = <String>[].obs;

  var dropdownItemBikeList = [].obs;
  var dropdownItemBikeListNames = <String>[].obs;

  var dropdownItemBatteryList = [].obs;
  var dropdownItemBatteryListNames = <String>[].obs;

  var dropDownItemIncidentTypeList = <String>[].obs;

  var isFormUncompleted = "".obs;
  var indexWhereFormIsNotCompleted = "".obs;
  var veloFormNotCompleted = "".obs;
  var success = "".obs;

  var technicianSelfAttributeIncident = true.obs;

  @override
  void onInit() {
    userToken = Get.find<LoginController>().userToken;
    userType = Get.find<LoginController>().userType;
    // Fetch all the labels
    if (userType == "User" || userType == 'SuperUser') {
      fetchBikeLabelsByGroupOnInit(-1);
    } else if (userType == "Client") {
      fetchGroupLabelsWithoutClient();
    } else {
      fetchClientLabelsByUserOnInit();
    }
    fetchIncidentLabels();
    super.onInit();
  }

  void fetchClientLabelsByUserOnInit() async {
    try {
      isLoadingLabelClient(true);
      dropdownItemClientList.clear();
      var clientLabels = await HttpService.fetchClientLabelsByUser(userToken);
      if (clientLabels != null) {
        var isLabelsPresent = [];
        clientLabels.map((label) {
          if (!isLabelsPresent.contains(label.name)) {
            // Add the list to the dropDownClientItemList
            dropdownItemClientList
                .add({'label': label.name, 'value': label.clientPk.toString()});
            // Add the list to the dropdownItemClientListNames
            dropdownItemClientListNames.add(label.name);
            isLabelsPresent.add(label.name);
          }
        }).toList();
        dropdownItemClientList.refresh();
        isLoadingLabelClient(false);

        if (dropdownItemClientList.length == 1 && userType == "user") {
          informations["Client"] = dropdownItemClientList[0]["value"];
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchGroupLabelsByClient() async {
    int clientPk = getClientItem();
    try {
      dropdownItemGroupList.clear();
      dropdownItemGroupListNames.clear();
      var groupLabels =
          await HttpService.fetchGroupLabelsByClient(clientPk, userToken);
      if (groupLabels != null) {
        var isLabelsPresent = [];
        groupLabels.map((label) {
          if (!isLabelsPresent.contains(label.name)) {
            dropdownItemGroupList
                .add({'label': label.name, 'value': label.groupePk.toString()});
            // Add the list to the dropdownItemClientListNames
            dropdownItemGroupListNames.add(label.name);
            isLabelsPresent.add(label.name);
          }
        }).toList();
        dropdownItemGroupList
            .insert(0, {'label': 'Pas de groupe', 'value': (-1).toString()});
        dropdownItemGroupListNames.insert(0, "Pas de groupe");

        dropdownItemGroupList.refresh();
        isLoadingLabelGroup(false);
        clientLabelPicked(true);
      }
    } catch (e) {
      print("groupLabels controller $e");
    }
  }

  void fetchGroupLabelsWithoutClient() async {
    int clientPk = -1;
    try {
      dropdownItemGroupList.clear();
      dropdownItemGroupListNames.clear();
      var groupLabels =
          await HttpService.fetchGroupLabelsByClient(clientPk, userToken);
      if (groupLabels != null) {
        var isLabelsPresent = [];
        groupLabels.map((label) {
          if (!isLabelsPresent.contains(label.name)) {
            dropdownItemGroupList
                .add({'label': label.name, 'value': label.groupePk.toString()});
            // Add the list to the dropdownItemClientListNames
            dropdownItemGroupListNames.add(label.name);
            isLabelsPresent.add(label.name);
          }
        }).toList();
        dropdownItemGroupList
            .insert(0, {'label': 'Pas de groupe', 'value': (-1).toString()});
        dropdownItemGroupListNames.insert(0, "Pas de groupe");
        print(dropdownItemGroupListNames);
        dropdownItemGroupList.refresh();
        isLoadingLabelGroup(false);
        clientLabelPicked(true);
      }
    } catch (e) {
      print("groupLabels controller $e");
    }
  }

  void fetchBikeLabelsByGroup() async {
    print("FECTH");
    int groupPk = getGroupItem();
    int clientPk = getClientItem();
    try {
      isLoadingLabelBike(true);
      dropdownItemBikeList.clear();
      dropdownItemBikeListNames.clear();
      dropdownItemBatteryListNames.clear();
      dropdownItemBatteryList.clear();
      var bikeLabels = await HttpService.fetchBikeLabelsByGroup(
          groupPk, clientPk, userToken);
      if (bikeLabels != null) {
        var isLabelsPresent = [];
        bikeLabels.map((label) {
          if (!isLabelsPresent.contains(label.name)) {
            dropdownItemBikeList
                .add({'label': label.name, 'value': label.veloPk.toString()});
            // Add the list to the dropdownItemClientListNames
            dropdownItemBikeListNames.add(label.name);
            if (label.batterie != "")
              dropdownItemBatteryListNames.add(label.batterie);
            isLabelsPresent.add(label.name);
          }
        }).toList();
        dropdownItemBikeList.refresh();
        dropdownItemBatteryList.refresh();
        isLoadingLabelBike(false);
        groupLabelPicked(true);
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchBikeLabelsByGroupOnInit(int id) async {
    try {
      isLoadingLabelBike(true);
      dropdownItemBikeList.clear();
      dropdownItemBikeListNames.clear();
      dropdownItemBatteryListNames.clear();
      dropdownItemBatteryList.clear();
      var bikeLabels = await HttpService.fetchBikeLabelsByGroup(
          id, getClientItem(), userToken);
      if (bikeLabels != null) {
        var isLabelsPresent = [];
        bikeLabels.map((label) {
          if (!isLabelsPresent.contains(label.name)) {
            dropdownItemBikeList
                .add({'label': label.name, 'value': label.veloPk.toString()});
            // Add the list to the dropdownItemClientListNames
            dropdownItemBikeListNames.add(label.name);
            if (label.batterie != "")
              dropdownItemBatteryListNames.add(label.batterie);
            isLabelsPresent.add(label.name);
          }
        }).toList();
        dropdownItemBikeList.refresh();
        dropdownItemBatteryList.refresh();
        isLoadingLabelBike(false);
        groupLabelPicked(true);
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchIncidentLabels() async {
    try {
      isLoadingLabelIncidentType(true);
      var incidentLabels = await HttpService.fetchIncidentLabels(userToken);
      if (incidentLabels != null) {
        incidentLabels.map((incidentLabel) {
          dropDownItemIncidentTypeList.add(incidentLabel);
        }).toList();
        dropDownItemIncidentTypeList.refresh();
      }
      isLoadingLabelIncidentType(false);
    } catch (e) {
      print(e);
    }
  }

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

    print("IFL after $incidentMoreFormsList");

    index--;
  }

  setClientLabel(value) {
    // Check if the client value has changed
    if (value != informations["Client"]) {
      // Set client label value
      informations["Client"] = value;

      // Put all inputs to disable status
      clientLabelPicked(false);
      groupLabelPicked(false);
      bikeLabelPicked(false);

      // Reset values
      informations["Groupe"] = "";
      informations["Vélo"] = "";
      informations["Batterie"] = "";

      // Fetch new groups
      fetchGroupLabelsByClient();
    }
  }

  setGroupLabel(value) {
    print(value);
    print(informations["Groupe"]);
    print(informations["Client"]);
    if (value != informations["Groupe"]) {
      // Set client label value
      informations["Groupe"] = value;

      // Put bike and battery inputs to disable status
      groupLabelPicked(false);
      bikeLabelPicked(false);

      // Reset values
      informations["Vélo"] = "";
      informations["Batterie"] = "";

      // Fetch new bikes labels
      fetchBikeLabelsByGroup();
    }
  }

  setBikeLabel(value) {
    if (value != informations["Vélo"]) {
      // Set client label value
      informations["Vélo"] = value;

      //Put battery label to disable status
      bikeLabelPicked(true);

      // Reset values
      informations["Batterie"] = "";

      veloFormNotCompleted.value = "";
    }
  }

  setBatteryLabel(value) {
    if (value != informations["Batterie"]) {
      informations["Batterie"] = value;
    }
  }

  // set the value of each incident TYPE in the state;
  setIncidentTypeLabel(value, index) {
    incidentTypeList[index] = value;

    if (index.toString() == indexWhereFormIsNotCompleted.value)
      indexWhereFormIsNotCompleted.value = "";
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

  // Get the clientPk linked to the right client name
  getClientItem() {
    var clientLabel = dropdownItemClientList
        .firstWhere((item) => item["label"] == informations["Client"]);
    return int.parse(clientLabel["value"]);
  }

  // Get the groupPk linked to the right client name
  getGroupItem() {
    var groupLabel = dropdownItemGroupList
        .firstWhere((item) => item["label"] == informations["Groupe"]);
    return int.parse(groupLabel["value"]);
  }

  // Get the veloPk linked to the right client name
  getBikeItem() {
    var bikeLabel = dropdownItemBikeList
        .firstWhere((item) => item["label"] == informations["Vélo"]);
    return int.parse(bikeLabel["value"]);
  }

  // Send the incident to the server if
  Future<void> sendIncident(int? veloPkFromScan) async {
    isFormUncompleted.value = "";
    success.value = "";

    // Check if informations are complete
    print(bikeLabelPicked);
    print(veloFormNotCompleted.value);
    if (!bikeLabelPicked.value) {
      veloFormNotCompleted.value = "Le champ vélo n'est pas spécifié";
      return;
    } else {
      veloFormNotCompleted.value = "";
    }
    if (incidentTypeList.contains("")) {
      indexWhereFormIsNotCompleted.value =
          incidentTypeList.indexWhere((element) => element == "").toString();
      isFormUncompleted.value = "Un champ n'est pas spécifié.";
      return;
    } else {
      indexWhereFormIsNotCompleted.value = "";
    }

    List<int> incidentFormAllList = List.from(incidentMoreFormsList);
    // Add an index form to add the first form that is not optional
    incidentFormAllList.insert(0, 0);

    List<IncidentToSendModel> incidentsToSend = [];

    // Loop threw all the incidents
    int veloPk;
    if (veloPkFromScan != null)
      veloPk = veloPkFromScan;
    else {
      if (userType == "user") {
        veloPk = Get.find<LoginController>().userBikeID.value;
      } else {
        veloPk = getBikeItem();
      }
    }

    incidentFormAllList.forEach((index) {
      IncidentToSendModel incident = IncidentToSendModel(
          veloPk: veloPk.toString(),
          type: incidentTypeList[index],
          commentary: incidentCommentList[index],
          files: incidentPhotosList[index],
          isSelfAttributed: technicianSelfAttributeIncident.value);
      incidentsToSend.add(incident);
    });

    // Send all the incidents
    incidentsToSend.map((incidentToSend) async {
      try {
        var incidentSent =
            await HttpService.setIncident(incidentToSend, userToken);
        if (incidentSent != null) {
          print("Success $incidentSent");
          success.value = incidentSent.toString();
          Get.find<IncidentController>().refreshIncidentsList();
        }
      } catch (e) {
        print(e);
      }
    }).toList();
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
    informations["client"] = "";
    informations["group"] = "";
    informations["bike"] = "";
    informations["battery"] = "";
  }
}
