// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

// Helpers
import 'package:velyvelo/models/incident/incidents_model.dart';

class IncidentHistoricCard extends StatelessWidget {
  final Incident data;
  final bool isHistorique;

  const IncidentHistoricCard(
      {Key? key, required this.data, required this.isHistorique})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          isHistorique ? const EdgeInsets.all(0.0) : const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
              Text(data.dateCreation,
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
          ),
          isHistorique
              ? const Divider(
                  color: Colors.black,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
