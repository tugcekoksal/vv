// Vendor
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/models/incident/refresh_incident_model.dart';
import 'package:velyvelo/models/incident/incident_to_send_model.dart';

// Services
import 'package:velyvelo/services/bikes/bike_id_user_service.dart';
import 'package:velyvelo/services/bikes/bike_user_service.dart';
import 'package:velyvelo/services/bikes/get_all_bikes_service.dart';
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
import 'package:velyvelo/services/hubs/fetch_all_hubs.dart';

class HttpService {
  // static String urlServer = "https://dms.velyvelo.com";
  static String urlServer = "http://192.168.10.112:8000";

  // Fetch all the group labels
  static Future addDeviceToken(String userToken) async {
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
      print("Token successfully added");
    } else {
      print('Token : error while adding to db');
    }
  }

  // Login the user
  static Future loginUser(String login, String password) async {
    return loginUserService(urlServer, login, password);
  }

  // Fetch the user's bike id
  static Future fetchBikeIDUser(String userToken) async {
    return fetchBikeIDUserService(urlServer, userToken);
  }

  // Fetch the user's bike
  static Future fetchUserBike(int veloPk, String userToken) async {
    return fetchUserBikeService(urlServer, veloPk, userToken);
  }

  // Fetch the hubs for map
  static Future fetchHubs(String userToken) async {
    return fetchHubsService(urlServer, userToken);
  }

  // Fetch one hub for map popup
  static Future fetchOneHub(int groupPk, String userToken) async {
    return fetchOneHubService(urlServer, groupPk, userToken);
  }

  // Fetch the user's type
  static Future fetchTypeUser(String userToken) async {
    return fetchTypeUserService(urlServer, userToken);
  }

  // Fetch All the incidents
  static Future fetchAllIncidents(
      RefreshIncidentModel incidentsToFetch, String userToken) async {
    return fetchAllIncidentsService(urlServer, incidentsToFetch, userToken);
  }

  // Fetch informations about a specific reparation
  static Future fetchReparationByPk(String incidentPk, String userToken) {
    return fetchReparationByPkService(urlServer, incidentPk, userToken);
  }

  // Fetch an incident by id
  static Future fetchIncidentById(int id, String userToken) async {
    return fetchIncidentByIdService(urlServer, id, userToken);
  }

  // Fetch All bikes
  static Future fetchAllBikes(
      List filtersList, List statusList, String userToken) async {
    return fetchAllBikesService(urlServer, filtersList, statusList, userToken);
  }

  // Fetch map's filters
  static Future fetchMapfilters(String userToken) async {
    return fetchMapfiltersService(urlServer, userToken);
  }

  // Fetch all the client labels
  static Future fetchClientLabelsByUser(String userToken) async {
    return fetchClientLabelsByUserService(urlServer, userToken);
  }

  // Fetch all the group labels
  static Future fetchGroupLabelsByClient(int clientPk, String userToken) async {
    return fetchGroupLabelsByClientService(urlServer, clientPk, userToken);
  }

  // Fetch all the bike labels
  static Future fetchBikeLabelsByGroup(int groupPk, String userToken) async {
    return fetchBikeLabelsByGroupService(urlServer, groupPk, userToken);
  }

  // Fetch all the incident type labels
  static Future fetchIncidentLabels(String userToken) async {
    return fetchIncidentLabelsService(urlServer, userToken);
  }

  // Send a incident
  static Future setIncident(
      IncidentToSendModel incident, String userToken) async {
    return setIncidentService(urlServer, incident, userToken);
  }

  // Set a bike on robbed status
  static Future setBikeRobbed(int id, bool robbed, String userToken) async {
    return setBikeRobbedService(urlServer, id, robbed, userToken);
  }

  // Set a bike status in detail page
  static Future sendCurrentDetailBikeStatus(
      Reparation reparation, String userToken) async {
    return sendCurrentDetailBikeStatusService(urlServer, reparation, userToken);
  }

  static Future fetchPieceFromType(
      int interventionType, int reparationType, String userToken) async {
    return fetchPieceFromTypeService(
        urlServer, interventionType, reparationType, userToken);
  }
}
