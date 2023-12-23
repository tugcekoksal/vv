import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/screens/views/incident_declaration/declaration_send_button.dart';
import 'package:velyvelo/screens/views/incident_declaration/incident_declaration_scrollview.dart';
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

class IncidentDeclaration extends StatelessWidget {
  final DeclarationInfoContainer? infoContainer;

  const IncidentDeclaration({super.key, this.infoContainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColorfulSafeArea(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            // looseFocus(context);
          },
          child: Stack(children: [
            IncidentDeclarationScrollview(infoContainer: infoContainer),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReturnBar(text: "Déclaration d'incidents"),
                  DeclarationSendButton(),
                ])
          ]),
        ),
      ),
    );
  }
}
