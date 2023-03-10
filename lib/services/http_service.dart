// Vendor
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:velyvelo/controllers/carte_provider/carte_bike_provider.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/bike/user_bike_model.dart';
import 'package:velyvelo/models/carte/bike_list_model.dart';
import 'package:velyvelo/models/carte/bike_map_model.dart';
import 'package:velyvelo/models/carte/hub_list_model.dart';
import 'package:velyvelo/models/carte/hub_map_model.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';

// Models
import 'package:velyvelo/models/incident/refresh_incident_model.dart';
import 'package:velyvelo/models/incident/incident_to_send_model.dart';
import 'package:velyvelo/models/json_usefull.dart';
import 'package:velyvelo/models/map/map_filter_model.dart';

// Services
import 'package:velyvelo/services/bikes/bike_id_user_service.dart';
import 'package:velyvelo/services/bikes/bike_user_service.dart';
import 'package:velyvelo/services/bikes/get_bike_map.dart';
import 'package:velyvelo/services/bikes/send_bike_status_service.dart';
import 'package:velyvelo/services/bikes/set_bike_robbed_service.dart';
import 'package:velyvelo/services/incidents/get_all_incidents_service.dart';
import 'package:velyvelo/services/incidents/get_incident_by_id_service.dart';
import 'package:velyvelo/services/incidents/set_incident_service.dart';
import 'package:velyvelo/services/labels/get_bike_labels_by_group_service.dart';
import 'package:velyvelo/services/labels/get_client_labels_by_user_service.dart';
import 'package:velyvelo/services/labels/get_group_labels_by_client_service.dart';
import 'package:velyvelo/services/labels/get_incident_labels_service.dart';
import 'package:velyvelo/services/login/login_user_service.dart';
import 'package:velyvelo/services/login/type_user_service.dart';
import 'package:velyvelo/services/map/get_map_filters_service.dart';
import 'package:velyvelo/services/hubs/fetch_hub_map.dart';

class HttpService {
  // static String urlServer = "https://dms.velyvelo.com";
  // static String urlServer = "http://192.168.10.119:8000";
  static String urlServer = "http://localhost:8000";

  // Fetch all the group labels
  static Future addDeviceToken(String userToken) async {
    final log = logger(HttpService);

    String? userDeviceToken = await FirebaseMessaging.instance.getToken();
    var request =
        http.MultipartRequest('POST', Uri.parse("$urlServer/api/assignUID/"));
    request.fields.addAll({
      'token': userDeviceToken.toString(),
    });
    var headers = {'Authorization': 'Token $userToken'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log.d("Token successfully added");
    } else {
      log.e('Token : error while adding to db');
    }
  }

  // Login the user
  static Future<String> loginUser(String login, String password) async {
    return loginUserService(urlServer, login, password);
  }

  // Delete account
  static Future<String> deleteUser(String token, String password) async {
    return deleteUserService(urlServer, token, password);
  }

  // Fetch the user's bike id
  static Future fetchBikeIDUser(String userToken) async {
    return fetchBikeIDUserService(urlServer, userToken);
  }

  // Fetch the user's bike
  static Future<UserBikeModel> fetchUserBike(
      int? veloPk, String? nomVelo, String userToken) async {
    return fetchUserBikeService(urlServer, veloPk, nomVelo, userToken);
  }

  // Fetch the hubs for map
  static Future<List<HubMapModel>> fetchHubMap(
      String search, String userToken) async {
    return fetchHubMapService(urlServer, search, userToken);
  }

  // Fetch the hubs for map
  static Future<List<HubListModel>> fetchHubList(
      String search, ItemRefresher itemRefresher, String userToken) async {
    return fetchHubListService(urlServer, search, itemRefresher, userToken);
  }

  // Fetch the user's type
  static Future<String> fetchTypeUser(String userToken) async {
    return fetchTypeUserService(urlServer, userToken);
  }

  // Fetch All the incidents
  static Future<IncidentsModel> fetchAllIncidents(
      RefreshIncidentModel incidentsToFetch,
      String searchText,
      String userToken) async {
    return fetchAllIncidentsService(
        urlServer, incidentsToFetch, searchText, userToken);
  }

  // Fetch informations about a specific reparation
  static Future fetchIncident(String incidentPk, String userToken) {
    return fetchIncidentService(urlServer, incidentPk, userToken);
  }

  // Fetch filters for incident page (group + client filters)
  static Future fetchIncidentFilters(String userToken) {
    return fetchIncidentFiltersService(urlServer, userToken);
  }

  // Fetch an incident by id
  static Future fetchIncidentById(int id, String userToken) async {
    return fetchIncidentByIdService(urlServer, id, userToken);
  }

  // Fetch Bike Pos on Map view velo
  static Future<List<BikeMapModel>> fetchBikeMap(List<String> filtersList,
      List<String> statusList, String searchText, String userToken) async {
    return fetchBikeMapService(
        urlServer, filtersList, statusList, searchText, userToken);
  }

  // Fetch Bike Popup on Map view velo
  static Future<BikePopupModel> fetchBikePopup(int id, String userToken) async {
    return fetchBikePopupService(urlServer, id, userToken);
  }

  // Fetch Bike Popup on Map view velo
  static Future<HubListModel> fetchHubPopup(int id, String userToken) async {
    return fetchHubPopupService(urlServer, id, userToken);
  }

  // Fetch Bike card list info on list view velo
  static Future<List<BikeListModel>> fetchBikeList(
      List<String> filtersList,
      List<String> statusList,
      String searchText,
      ItemRefresher itemRefresher,
      String userToken) async {
    return fetchBikeListService(urlServer, filtersList, statusList, searchText,
        itemRefresher, userToken);
  }

  // Fetch map's filters
  static Future<GroupFilterModel> fetchGroupFilters(String userToken) async {
    return fetchGroupFilterService(urlServer, userToken);
  }

  // Fetch all the client labels
  static Future<List<IdAndName>> fetchClientLabelsByUser(
      String userToken) async {
    return fetchClientLabelsByUserService(urlServer, userToken);
  }

  // Fetch all the group labels
  static Future<List<IdAndName>> fetchGroupLabelsByClient(
      int clientPk, String userToken) async {
    return fetchGroupLabelsByClientService(urlServer, clientPk, userToken);
  }

  // Fetch all the bike labels
  static Future<List<IdAndName>> fetchBikeLabelsByGroup(
      int groupPk, int clientPk, String userToken) async {
    return fetchBikeLabelsByGroupService(
        urlServer, groupPk, clientPk, userToken);
  }

  // Fetch all the incident type labels
  static Future<List<IdAndName>> fetchIncidentLabels(String userToken) async {
    return fetchIncidentLabelsService(urlServer, userToken);
  }

  // Send a incident
  static Future<String> setIncident(
      IncidentToSendModel incident, String userToken) async {
    return setIncidentService(urlServer, incident, userToken);
  }

  // Set a bike on robbed status
  static Future<String> setBikeRobbed(
      int id, bool robbed, String userToken) async {
    return setBikeRobbedService(urlServer, id, robbed, userToken);
  }

  // Set a bike status in detail page
  static Future<String> sendCurrentDetailBikeStatus(
      ReparationModel reparation, String userToken) async {
    return sendCurrentDetailBikeStatusService(urlServer, reparation, userToken);
  }

  static Future fetchPieceFromType(
      int interventionType, int reparationType, String userToken) async {
    return fetchPieceFromTypeService(
        urlServer, interventionType, reparationType, userToken);
  }
}
