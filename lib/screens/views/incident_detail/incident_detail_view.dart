// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/incident/incident_card_model.dart';
import 'package:velyvelo/screens/views/incident_detail/header_container.dart';
import 'package:velyvelo/screens/views/incident_detail/informations_container.dart';
import 'package:velyvelo/screens/views/incident_detail/incident_container.dart';
import 'package:velyvelo/screens/views/incident_detail/reparation/reparation_container.dart';
import 'package:velyvelo/screens/views/incident_detail/reparation/save_button.dart';
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

// Labels to put on bike
var dropdownItemList = <String>["Rangé", "Utilisé", "Volé"];

class IncidentDetail extends StatelessWidget {
  IncidentDetail({super.key, required this.incident});

  final IncidentCardModel incident;

  final IncidentController incidentController = Get.put(IncidentController());
  final LoginController loginController = Get.put(LoginController());

  void init() {
    incidentController.fetchReparation(incident.incidentPk);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: global_styles.backgroundLightGrey,
        body: ColorfulSafeArea(
            color: Colors.white,
            child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  // var currentFocus = FocusScope.of(context);

                  // if (!currentFocus.hasPrimaryFocus) {
                  //   currentFocus.unfocus();
                  // }
                },
                child: Stack(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 65, 0, 0),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 50, top: 10, left: 20, right: 20),
                          child: Column(
                            children: [
                              // Button to return to the incidents historic
                              // Container header with recap of the incident
                              HeaderContainer(
                                incident: incident,
                              ),
                              // Container informations with "Groupe" and "Vélo" names
                              InformationsContainer(
                                  incidentController: incidentController),
                              // Container type incident + photos incidents
                              IncidentContainer(
                                  incidentController: incidentController),
                              // Container to have and update reparation informations
                              ReparationContainer(
                                loginController: loginController,
                                incidentController: incidentController,
                              ),
                              const SizedBox(height: 10)
                            ],
                          ),
                        ),
                      )),
                  ReturnBar(
                      text: "Détails de l'incident",
                      rightIcon: loginController.userTypeFetched.clientType ==
                                  "Particulier" ||
                              loginController.userTypeFetched.clientType ==
                                  "Auto-entrepeneur"
                          ? GestureDetector(
                              onTap: () {
                                final Uri url = Uri.parse(
                                    'https://calendly.com/velyvelo/rdv-atelier?email=${loginController.userTypeFetched.email}&first_name=${loginController.userTypeFetched.firstName}&last_name=${loginController.userTypeFetched.lastName}&a1=33${loginController.userTypeFetched.phone}&a2=${incidentController.currentReparation.value.numeroCadran}&a3=${incidentController.currentReparation.value.typeContrat}&a4=${incident.reparationNumber}&a5=${incident.incidentTypeReparation}');
                                launchUrl(url);
                              },
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    "assets/calendly-logo.png",
                                    fit: BoxFit.contain,
                                  )))
                          : null,
                      optionalFunction: () =>
                          incidentController.fetchAllIncidents(
                              incidentController.incidentsToFetch.value)),
                  if (loginController.userTypeFetched.userType ==
                          "Technicien" ||
                      loginController.userTypeFetched.userType == "Admin")
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SaveButton(
                            incidentController: incidentController,
                            loginController: loginController)
                      ],
                    )
                ]))));
  }
}
