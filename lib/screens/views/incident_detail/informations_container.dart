// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/screens/views/bike_profile/bike_profile_view.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Informations",
                  style: TextStyle(
                      color: global_styles.purple,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600)),
              GestureDetector(
                onTap: () {
                  Get.to(
                      () => MyBikeView(
                          isFromScan: false,
                          veloPk: incidentController
                                  .incidentDetailValue.value.velo.id ??
                              0),
                      transition: Transition.downToUp,
                      duration: const Duration(milliseconds: 400));
                },
                child: Row(
                  children: const [
                    Icon(Icons.pedal_bike, color: global_styles.blue),
                    SizedBox(width: 10),
                    Text(
                      "page vélo >>",
                      style: TextStyle(
                          color: global_styles.blue,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          incidentController.incidentDetailValue.value.groupe == ""
              ? const SizedBox()
              : RichText(
                  text: TextSpan(
                    text: 'Groupe ',
                    style: const TextStyle(
                        color: global_styles.greyText,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                    children: <TextSpan>[
                      TextSpan(
                          text: incidentController
                              .incidentDetailValue.value.groupe,
                          style: const TextStyle(
                              color: global_styles.lightGreyText)),
                    ],
                  ),
                ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  text: 'Vélo ',
                  style: const TextStyle(
                      color: global_styles.greyText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700),
                  children: <TextSpan>[
                    TextSpan(
                        text: incidentController
                            .incidentDetailValue.value.velo.name,
                        style: const TextStyle(
                            color: global_styles.lightGreyText)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
