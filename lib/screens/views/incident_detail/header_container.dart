// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';
import 'package:velyvelo/helpers/statusColorBasedOnStatus.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';

class HeaderContainer extends StatelessWidget {
  final Incident incident;
  const HeaderContainer({Key? key, required this.incident}) : super(key: key);

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
              Expanded(
                child: Text(
                    incident.incidentTypeReparation ??
                        "Pas de type de réparation",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
              // Little top right colored box indicating the reparation number
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 100),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: colorBasedOnIncidentStatus(
                          incident.incidentStatus ??
                              "Pas de status d'incident"),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(valueIsNull(incident.reparationNumber),
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
                child: Text(incident.veloGroup,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
              Text(" - ",
                  style: TextStyle(
                      color: GlobalStyles.purple,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600)),
              Flexible(
                child: Text(valueIsNull(incident.veloName),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
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
                    (incident.interventionTime != 0
                            ? incident.interventionTime.toString()
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
