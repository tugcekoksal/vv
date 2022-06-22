import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/models/map/map_filter_model.dart';
import 'package:velyvelo/services/http_service.dart';

class BikeFilter {
  String searchText = "";
  bool displaySearch = false;

  bool isLoadingGroups = false;

  // Groups filters
  List<String> availableGroupsList = <String>["Chargement des filtres"];
  List<String> selectedGroupsList = <String>[];
  List<String> oldSelectedGroupsList = <String>[];

  // Status filters
  List<String> availableStatus = <String>["Rangé", "Utilisé", "Volé"];
  List<String> selectedStatusList = <String>[];
  List<String> oldSelectedStatusList = <String>[];

  BikeFilter();

  final log = logger(BikeFilter);

  Future<String?> fetchFilters(String userToken) async {
    try {
      isLoadingGroups = true;

      GroupFilterModel filters = await HttpService.fetchGroupFilters(userToken);
      availableGroupsList = filters.groups;
    } catch (e) {
      log.d(e.toString());
      return "Il y a une erreur avec les données. Excusez-nous de la gêne occasionnée.";
    }
    isLoadingGroups = false;
    return null;
  }

  bool isEmpty() {
    if (selectedStatusList.isNotEmpty) {
      return false;
    }
    if (selectedGroupsList.isNotEmpty) {
      return false;
    }
    return true;
  }

  void setFilters(value, label) {
    if (!value) {
      selectedGroupsList.remove(label);
    } else {
      selectedGroupsList.add(label);
    }
  }

  void setStatus(value, label) {
    if (!value) {
      selectedStatusList.remove(label);
    } else {
      selectedStatusList.add(label);
    }
  }

  void onChangeFilters() {
    oldSelectedGroupsList = List.from(selectedGroupsList);
    oldSelectedStatusList = List.from(selectedStatusList);
  }

  void toggleSearch(bool isSearch) {
    displaySearch = isSearch;
  }
}
