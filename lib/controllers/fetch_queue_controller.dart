import 'dart:async';
import 'dart:io';

import 'package:velyvelo/config/caching_data.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/services/http_service.dart';

final fetchQueueProvider = FetchQueue();

class FetchQueue {
  List<ReparationModel> updateQueue = [];
  String? userToken;
  Timer? timer;

  FetchQueue();

  void init() {}

  void cronJob(String token) {
    userToken = token;
    timer = null;
    if (userToken == null) return;
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => fetchQueueQueries());
  }

  void fetchQueueQueries() async {
    if (userToken == null) return;
    for (ReparationModel rep in updateQueue) {
      try {
        await HttpService.sendCurrentDetailBikeStatus(rep, userToken!);
        updateQueue.remove(rep);
        await writeUpdateIncident(updateQueue);
        break;
      } on SocketException {
        // print("Waiting for connexion to empty the queue of queries");
        // Still offline this is a normal behavior
      } catch (e) {
        // Remove bad request
        log.e(e.toString());
        updateQueue.remove(rep);
      }
    }
  }
}
