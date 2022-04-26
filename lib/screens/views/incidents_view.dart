// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Components
import 'package:velyvelo/components/BuildIncidentOverview.dart';
import 'package:velyvelo/components/BuildLoadingBox.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/screens/views/incident_detail/incident_detail_view.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';
import 'package:velyvelo/helpers/statusColorBasedOnStatus.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class IncidentsView extends StatelessWidget {
  IncidentsView({Key? key}) : super(key: key);

  final IncidentController incidentController = Get.put(IncidentController());

  showIncidentDetailPage(data) async {
    int incidentID = int.parse(data.incidentPk);
    incidentController.currentIncidentId.value = incidentID;
    await incidentController.fetchIncidentById(incidentID);

    Get.to(() => IncidentDetail(incident: data));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: <Color>[
              Colors.grey,
              Colors.white,
            ])),
        child: Column(children: [
          SizedBox(height: 65.0),
          BuildIncidentsOverview(
            setFilterTab: incidentController.setStatusToDisplay,
          ),
          Obx(() {
            if (incidentController.isLoading.value) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return BuildLoadingBox(
                          child: Container(
                              padding: const EdgeInsets.all(20.0),
                              margin: const EdgeInsets.only(
                                  bottom: 8.0, left: 20.0, right: 20.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0)),
                              height: 100),
                        );
                      }));
            } else if (incidentController.error.value != '') {
              return Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      incidentController.error.value,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            } else if (incidentController.noIncidentsToShow.value) {
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_box_rounded,
                        color: GlobalStyles.green,
                        size: 50,
                      ),
                      Text(
                        "Aucun incidents",
                        style: TextStyle(
                            color: GlobalStyles.backgroundDarkGrey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        controller: incidentController.refreshController,
                        onRefresh: () {
                          // Refresh incidents
                          incidentController.refreshIncidentsList();
                          incidentController.refreshController
                              .refreshCompleted();
                        },
                        onLoading: () {
                          // Add new incidents in the list with newest_id and count
                          incidentController.fetchNewIncidents();
                          incidentController.refreshController.loadComplete();
                        },
                        child: ListView.builder(
                            itemCount: incidentController.incidentList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () => showIncidentDetailPage(
                                      incidentController.incidentList[index]),
                                  child: BuildIncidentHistoricTile(
                                      data: incidentController
                                          .incidentList[index]));
                            }),
                      )));
            }
          })
        ]));
  }
}

class BuildIncidentHistoricTile extends StatelessWidget {
  final Incident data;

  const BuildIncidentHistoricTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
          color: GlobalStyles.backgroundLightGrey,
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(valueIsNull(data.incidentTypeReparation),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 100),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: data.incidentStatus == null
                          ? GlobalStyles.greyLogin
                          : colorBasedOnIncidentStatus(data.incidentStatus!),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: Text(valueIsNull(data.incidentStatus),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
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
                child: Text(data.veloName + " / " + data.veloGroup,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 7.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(valueIsNull(data.dateCreation),
                  style: TextStyle(
                      color: GlobalStyles.green,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.schedule,
                    color: GlobalStyles.purple,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    (data.interventionTime != 0
                            ? data.interventionTime.toString()
                            : "moins d'1") +
                        'h',
                    style: TextStyle(
                        color: GlobalStyles.purple,
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
