// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_in_progress.dart';
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

// Views
import 'package:velyvelo/screens/views/incidents_declaration.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';

// Components
import 'package:velyvelo/components/BuildLoadingBox.dart';
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_history_container.dart';

// Service Url
import 'package:velyvelo/services/http_service.dart';
import 'package:flutter/cupertino.dart';

class MyBikeView extends StatefulWidget {
  final bool isFromScan;
  final int veloPk;

  MyBikeView({Key? key, required this.isFromScan, this.veloPk = 0})
      : super(key: key);

  @override
  _MyBikeViewState createState() => _MyBikeViewState();
}

class _MyBikeViewState extends State<MyBikeView> {
  final BikeController bikeController = Get.put(BikeController());
  bool bikeIsRobbed = false;
  @override
  void initState() {
    super.initState();
    bikeIsRobbed = bikeController.userBike.value.isStolen;
    if (!widget.isFromScan) {
      setState(() {
        bikeController.fetchUserBike(widget.veloPk);
      });
    }
  }

  void showConfirmStolenBikeDialog() {
    BuildContext savePageContext = context;
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Déclarer un vol"),
          content:
              Text("Êtes-vous sûr de vouloir déclarer votre vélo comme volé ?"),
          actions: [
            CupertinoDialogAction(
                child: Text("Annuler"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: Text("Confirmer"),
              onPressed: () async {
                setState(() {
                  bikeIsRobbed = !bikeIsRobbed;
                });
                Navigator.of(context).pop();

                await bikeController.setBikeToNewRobbedStatus(
                    bikeIsRobbed, bikeController.userBike.value.veloPk);
                final snackBar = SnackBar(
                  content: Text('Votre vélo a bien été déclaré comme volé !'),
                  backgroundColor: Color(0xff46b594),
                );

                // Find the Scaffold in the widget tree and use
                // it to show a SnackBar.

                ScaffoldMessenger.of(savePageContext).showSnackBar(snackBar);
                didChangeDependencies();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return ColorfulSafeArea(
        color: Colors.white,
        child: Stack(children: [
          Container(
              color: GlobalStyles.backgroundLightGrey,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 80, top: 20),
                    child: Container(
                      color: GlobalStyles.backgroundLightGrey,
                      child: Column(
                        children: [
                          Obx(() {
                            if (bikeController.isLoading.value) {
                              return BuildLoadingBox(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 20.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  height: screenHeight * 0.25,
                                ),
                              );
                            } else {
                              return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Image.network(
                                    bikeController.userBike.value.pictureUrl !=
                                            null
                                        ? HttpService.urlServer +
                                            bikeController
                                                .userBike.value.pictureUrl
                                                .toString()
                                        : "https://velyvelo.com/static/vitrine/gif/hp_cycliste_coursier.gif",
                                    height: screenHeight * 0.15,
                                  ));
                            }
                          }),
                          const SizedBox(height: 10.0),
                          Obx(() {
                            if (bikeController.isLoading.value) {
                              return BuildLoadingBox(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 20.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  height: 150,
                                ),
                              );
                            } else if (bikeController.error.value != '') {
                              return Center(
                                  child: Text(bikeController.error.value,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)));
                            } else {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 20.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Informations",
                                        style: TextStyle(
                                            color: GlobalStyles.purple,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Groupe ',
                                        style: TextStyle(
                                            color: GlobalStyles.greyText,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: bikeController.userBike
                                                          .value.groupeName !=
                                                      null
                                                  ? bikeController
                                                      .userBike.value.groupeName
                                                  : "Aucun groupe",
                                              style: TextStyle(
                                                  color: GlobalStyles
                                                      .lightGreyText)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Kilométrage ',
                                        style: TextStyle(
                                            color: GlobalStyles.greyText,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: valueIsNull(bikeController
                                                      .userBike
                                                      .value
                                                      .kilometrage)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: GlobalStyles
                                                      .lightGreyText)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Client ',
                                        style: TextStyle(
                                            color: GlobalStyles.greyText,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: valueIsNull(bikeController
                                                  .userBike.value.clientName),
                                              style: TextStyle(
                                                  color: GlobalStyles
                                                      .lightGreyText)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Numéro Cadre ',
                                        style: TextStyle(
                                            color: GlobalStyles.greyText,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: valueIsNull(bikeController
                                                  .userBike.value.numeroCadran),
                                              style: TextStyle(
                                                  color: GlobalStyles
                                                      .lightGreyText)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Date de création ',
                                        style: TextStyle(
                                            color: GlobalStyles.greyText,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: valueIsNull(bikeController
                                                  .userBike.value.dateCreation),
                                              style: TextStyle(
                                                  color: GlobalStyles
                                                      .lightGreyText)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                          SizedBox(height: 20.0),
                          Center(
                              child: GestureDetector(
                            onTap: () => Get.to(
                                () => IncidentDeclaration(
                                      client: bikeController
                                          .userBike.value.clientName,
                                      velo: bikeController
                                          .userBike.value.bikeName,
                                      groupe: bikeController
                                          .userBike.value.groupeName,
                                      veloPk:
                                          bikeController.userBike.value.veloPk,
                                    ),
                                transition: Transition.downToUp,
                                duration: Duration(milliseconds: 400)),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: GlobalStyles.blue,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 15.0),
                                child: Text("Déclarer un incident",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600))),
                          )),
                          SizedBox(height: 20.0),
                          // Display title & list of current incidents
                          IncidentInProgress(bikeController: bikeController),
                          SizedBox(height: 10.0),
                          // Button & list of passed incidents
                          IncidentHistoryContainer(
                              bikeController: bikeController),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 30.0,
                                    right: 30.0,
                                    top: 20,
                                    bottom: 50.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Que faire en cas de vol ?",
                                        style: TextStyle(
                                            color: GlobalStyles.purple,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 10.0),
                                    Text(
                                        "Votre vélo a été volé ? Déclarez-le sur l'application à l'aide du bouton ci-dessous",
                                        style: TextStyle(
                                            color: GlobalStyles.purple,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ),
                              Positioned(
                                child: GestureDetector(
                                  onTap: () => showConfirmStolenBikeDialog(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: bikeIsRobbed
                                          ? Color(0xff46b594)
                                          : GlobalStyles.orange,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 18.0),
                                    child: Text(
                                        bikeIsRobbed
                                            ? "Mon vélo a été retrouvé"
                                            : "Déclarer mon vélo comme volé",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ))),
          Obx(() {
            return !this.widget.isFromScan
                ? ReturnBar(text: bikeController.userBike.value.bikeName)
                : ReturnBarScan(
                    bikeController: bikeController,
                    text: bikeController.userBike.value.bikeName);
          }),
        ]));
  }
}
