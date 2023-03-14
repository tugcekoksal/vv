import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';
import 'package:velyvelo/helpers/status_color_based_on_status.dart';
import 'package:velyvelo/models/incident/incident_card_model.dart';

class IncidentCard extends ConsumerWidget {
  final IncidentCardModel incident;

  const IncidentCard({Key? key, required this.incident}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider wProvider = ref.watch(incidentsProvider);

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
                child: Text(incident.clientName + " - " + incident.veloGroup,
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
                      color: colorBasedOnIncidentStatus(incident.incidentStatus,
                          isTechnicien: wProvider.loginController.isTech()),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: Text(incident.reparationNumber,
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
                child: Text(incident.incidentTypeReparation,
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
              Text(incident.veloName,
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
