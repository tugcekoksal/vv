// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

class InformationsContainer extends StatelessWidget {
  final IncidentController incidentController;

  const InformationsContainer({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informations",
              style: TextStyle(
                  color: GlobalStyles.purple,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10.0),
          incidentController.incidentDetailValue.value.groupe == "" ||
                  incidentController.incidentDetailValue.value.groupe == null
              ? SizedBox()
              : RichText(
                  text: TextSpan(
                    text: 'Groupe ',
                    style: TextStyle(
                        color: GlobalStyles.greyText,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                    children: <TextSpan>[
                      TextSpan(
                          text: incidentController
                              .incidentDetailValue.value.groupe,
                          style: TextStyle(color: GlobalStyles.lightGreyText)),
                    ],
                  ),
                ),
          SizedBox(height: 5.0),
          RichText(
            text: TextSpan(
              text: 'Vélo ',
              style: TextStyle(
                  color: GlobalStyles.greyText,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(
                    text: valueIsNull(
                        incidentController.incidentDetailValue.value.velo),
                    style: TextStyle(color: GlobalStyles.lightGreyText)),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          incidentController.incidentDetailValue.value.batteries == "" ||
                  incidentController.incidentDetailValue.value.batteries == null
              ? SizedBox()
              : RichText(
                  text: TextSpan(
                    text: 'Batterie ',
                    style: TextStyle(
                        color: GlobalStyles.greyText,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                    children: <TextSpan>[
                      TextSpan(
                          text: incidentController
                              .incidentDetailValue.value.batteries,
                          style: TextStyle(color: GlobalStyles.lightGreyText)),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
