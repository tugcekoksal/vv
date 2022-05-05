// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/models/incident/incidents_model.dart';
import 'package:velyvelo/screens/views/incident_detail/header_container.dart';
import 'package:velyvelo/screens/views/incident_detail/informations_container.dart';
import 'package:velyvelo/screens/views/incident_detail/reparation/reparation_container.dart';
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

// Service Url
import 'package:velyvelo/services/http_service.dart';

// Components
import 'package:velyvelo/components/BuildShowImageFullSlider.dart';

// Labels to put on bike
var dropdownItemList = <String>["Rangé", "Utilisé", "Volé"];

class IncidentDetail extends StatelessWidget {
  IncidentDetail({Key? key, required this.incident}) : super(key: key);

  final Incident incident;

  final IncidentController incidentController = Get.put(IncidentController());
  final LoginController loginController = Get.put(LoginController());

  void init() {
    incidentController.fetchReparation(incident.incidentPk);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
        backgroundColor: GlobalStyles.backgroundLightGrey,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Stack(children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 20.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Incident(s)",
                                style: TextStyle(
                                    color: GlobalStyles.purple,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 10.0),
                            RichText(
                              text: TextSpan(
                                text: "Type d'incident ",
                                style: TextStyle(
                                    color: GlobalStyles.greyText,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: valueIsNull(incidentController
                                          .incidentDetailValue
                                          .value
                                          .typeIncident),
                                      style: TextStyle(
                                          color: GlobalStyles.lightGreyText)),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            incidentController.incidentDetailValue.value
                                        .commentaire ==
                                    null
                                ? SizedBox()
                                : RichText(
                                    text: TextSpan(
                                      text: 'Commentaire associé : ',
                                      style: TextStyle(
                                          color: GlobalStyles.greyText,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: incidentController
                                                .incidentDetailValue
                                                .value
                                                .commentaire,
                                            style: TextStyle(
                                                color: GlobalStyles
                                                    .lightGreyText)),
                                      ],
                                    ),
                                  ),
                            SizedBox(height: 5.0),
                            RichText(
                              text: TextSpan(
                                  text: 'Photos ',
                                  style: TextStyle(
                                      color: GlobalStyles.greyText,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(height: 10),
                            incidentController
                                            .incidentDetailValue.value.photos ==
                                        null ||
                                    incidentController.incidentDetailValue.value
                                            .photos!.length ==
                                        0
                                ? Text(
                                    "Cet incident ne contient aucune photo",
                                    style: TextStyle(
                                        color: GlobalStyles.lightGreyText,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700),
                                  )
                                : GridView.count(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 3,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 5,
                                    children: incidentController
                                                .incidentDetailValue
                                                .value
                                                .photos ==
                                            null
                                        ? <String>[]
                                            .map((e) => ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => SliderShowFullmages(
                                                            mode: "Network",
                                                            listImagesModel:
                                                                incidentController
                                                                    .incidentDetailValue
                                                                    .value
                                                                    .photos!,
                                                            current:
                                                                incidentController
                                                                    .currentImageIndexInViewer
                                                                    .value)));
                                                  },
                                                  child: Image.asset(
                                                    e,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                )))
                                            .toList()
                                        : incidentController
                                            .incidentDetailValue.value.photos!
                                            .map((image) => ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) => SliderShowFullmages(
                                                                  mode:
                                                                      "Network",
                                                                  listImagesModel:
                                                                      incidentController
                                                                          .incidentDetailValue
                                                                          .value
                                                                          .photos!,
                                                                  current: 0)));
                                                    },
                                                    child: Image.network(
                                                      HttpService.urlServer +
                                                          image,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                  )
                          ],
                        ),
                      ),
                      ReparationContainer(
                        loginController: loginController,
                        incidentController: incidentController,
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        // boxShadow: [BoxShadow(color: Colors.red)],
                        color: GlobalStyles.backgroundLightGrey,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0))),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: ReturnContainer(text: "Détails de l'incident"),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // boxShadow: [BoxShadow(color: Colors.red)],
                        color: GlobalStyles.backgroundLightGrey,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            topLeft: Radius.circular(25.0))),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());

                        var snackBar = SnackBar(
                          content: Text(
                              'Votre demande est en cours de traitement...'),
                          backgroundColor: GlobalStyles.blue,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        await incidentController.sendReparationUpdate();

                        ScaffoldMessenger.of(context).clearSnackBars();
                        snackBar = SnackBar(
                          content: Text(
                              'Vos informations ont bien été sauvegardées.'),
                          backgroundColor: Color(0xff46b594),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: GlobalStyles.blue,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 20.0),
                        child: Text("Envoyer",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              )
            ])));
  }
}
