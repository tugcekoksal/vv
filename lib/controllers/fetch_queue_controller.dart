import 'dart:async';

import 'package:velyvelo/config/caching_data.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/services/http_service.dart';

final fetchQueueProvider = FetchQueue();

class FetchQueue {
  List<ReparationModel> updateQueue = [];
  String? userToken;
  Timer? timer;

  void cronJob(String token) {
    userToken = token;
    timer = null;
    if (userToken == null) return;
    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => fetchQueueQueries());
  }

  void fetchQueueQueries() async {
    if (userToken == null) return;
    try {
      for (ReparationModel rep in updateQueue) {
        await HttpService.sendCurrentDetailBikeStatus(rep, userToken!);
        updateQueue.remove(rep);
        await writeUpdateIncident(updateQueue);
        break;
      }
    } catch (e) {
      print("Waiting for connexion to empty the queue of queries");
      // Still offline this is a normal behavior
    }
  }
}
