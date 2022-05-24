// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:get/get.dart';

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';
import 'package:velyvelo/helpers/statusColorBasedOnStatus.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';

class HeaderContainer extends StatelessWidget {
  final IncidentController incidentController = Get.put(IncidentController());

  final Incident incident;
  HeaderContainer({Key? key, required this.incident}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Type reparation
              Obx(() {
                return Expanded(
                  child: Text(incidentController.actualTypeReparation.value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: global_styles.purple,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600)),
                );
              }),
              // Little top right colored box indicating the reparation number
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: colorBasedOnIncidentStatus(
                          incident.incidentStatus ??
                              "Pas de status d'incident"),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(valueIsNull(incident.reparationNumber),
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
                child: Text(incident.veloGroup,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: global_styles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
              const Text(" - ",
                  style: TextStyle(
                      color: global_styles.purple,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600)),
              Flexible(
                child: Text(valueIsNull(incident.veloName),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: global_styles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              )
            ],
          ),
          const SizedBox(height: 7.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(valueIsNull(incident.dateCreation),
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
                    (incident.interventionTime != 0
                            ? incident.interventionTime.toString()
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
