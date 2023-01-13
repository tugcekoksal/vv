// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Components
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/screens/views/incident_detail/incident_detail_view.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

// Helpers
import 'package:velyvelo/helpers/status_color_based_on_status.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

class IncidentsList extends StatelessWidget {
  final IncidentController incidentController;

  const IncidentsList({Key? key, required this.incidentController})
      : super(key: key);

  showIncidentDetailPage(data) async {
    int incidentID = int.parse(data.incidentPk);
    incidentController.currentIncidentId.value = incidentID;
    await incidentController.fetchIncidentById(incidentID);

    Get.to(() => IncidentDetail(incident: data),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
          child: FadeListView(
              child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: incidentController.refreshController,
        onRefresh: () {
          // Refresh incidents
          incidentController.refreshIncidentsList();
          incidentController.refreshController.refreshCompleted();
        },
        onLoading: () {
          // Add new incidents in the list with newest_id and count
          incidentController.fetchNewIncidents().then((isNotEmpty) {
            if (isNotEmpty) {
              incidentController.refreshController.loadComplete();
            } else {
              incidentController.refreshController.loadNoData();
            }
          });
        },
        child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            itemCount: incidentController.incidentList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => showIncidentDetailPage(
                      incidentController.incidentList[index]),
                  child: BuildIncidentHistoricTile(
                      data: incidentController.incidentList[index]));
            }),
      )));
    });
  }
}

class BuildIncidentHistoricTile extends StatelessWidget {
  final Incident data;
  final LoginController loginController = Get.put(LoginController());

  BuildIncidentHistoricTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // first line top left
              Expanded(
                child: Text(data.clientName + " - " + data.veloGroup,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: global_styles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
              // Little colored hint top right corner of incident card tile
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: colorBasedOnIncidentStatus(data.incidentStatus,
                          isTechnicien: loginController.isTech.value),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: Text(data.reparationNumber,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800))),
              )
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Flexible(
                child: Text(data.incidentTypeReparation,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: global_styles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 7.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.veloName,
                  style: const TextStyle(
                      color: global_styles.green,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.schedule,
                    color: global_styles.purple,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    (data.interventionTime != 0
                            ? data.interventionTime.toString()
                            : "moins d'1") +
                        'h',
                    style: const TextStyle(
                        color: global_styles.purple,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
