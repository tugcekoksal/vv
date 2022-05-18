import 'package:flutter/material.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/screens/views/incident_declaration/declaration_incidents_container.dart';
import 'package:velyvelo/screens/views/incident_declaration/declaration_information_container.dart';

class IncidentDeclarationScrollview extends StatelessWidget {
  final DeclarationInfoContainer? infoContainer;

  const IncidentDeclarationScrollview({Key? key, this.infoContainer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 65, 0, 0),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80, top: 10, left: 20, right: 20),
        child: Column(children: [
          DeclarationInformationContainer(
              client: infoContainer?.client,
              group: infoContainer?.group,
              velo: infoContainer?.velo),
          DeclarationIncidentsContainer(),
        ]),
      ),
    );
  }
}
