// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';
import 'package:velyvelo/models/bike/user_bike_model.dart';

// Views
import 'package:velyvelo/screens/views/incidents_declaration.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';

// Components
import 'package:velyvelo/components/BuildLoadingBox.dart';

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
        print(bikeController.userBike);
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
    return Stack(alignment: Alignment.center, children: [
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Obx(() {
              return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
                  child: Stack(alignment: Alignment.center, children: [
                    Text(bikeController.userBike.value.bikeName,
                        style: TextStyle(
                            color: GlobalStyles.greyText,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w700)),
                    Positioned(
                        left: 25.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20.0,
                          ),
                        ))
                  ]));
            }),
            const SizedBox(
              height: 20,
            ),
            !this.widget.isFromScan
                ? SizedBox()
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
                    child: Stack(alignment: Alignment.center, children: [
                      Text("Scannez un vélo",
                          style: TextStyle(
                              color: GlobalStyles.greyText,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w700)),
                      Positioned(
                          left: 25.0,
                          child: GestureDetector(
                            onTap: () {
                              bikeController.isViewingScanPage(false);
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20.0,
                            ),
                          ))
                    ])),
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
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    height: screenHeight * 0.25,
                  ),
                );
              } else {
                return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Image.network(
                      bikeController.userBike.value.pictureUrl != null
                          ? HttpService.urlServer +
                              bikeController.userBike.value.pictureUrl
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
                        borderRadius: BorderRadius.circular(20.0)),
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
                      const SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(
                          text: 'Nom ',
                          style: TextStyle(
                              color: GlobalStyles.greyText,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700),
                          children: <TextSpan>[
                            TextSpan(
                                text: valueIsNull(
                                    bikeController.userBike.value.bikeName),
                                style: TextStyle(
                                    color: GlobalStyles.lightGreyText)),
                          ],
                        ),
                      ),
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
                                text: bikeController
                                            .userBike.value.groupeName !=
                                        null
                                    ? bikeController.userBike.value.groupeName
                                    : "Aucun groupe",
                                style: TextStyle(
                                    color: GlobalStyles.lightGreyText)),
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
                                        .userBike.value.kilometrage)
                                    .toString(),
                                style: TextStyle(
                                    color: GlobalStyles.lightGreyText)),
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
                                text: valueIsNull(
                                    bikeController.userBike.value.clientName),
                                style: TextStyle(
                                    color: GlobalStyles.lightGreyText)),
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
                                text: valueIsNull(
                                    bikeController.userBike.value.numeroCadran),
                                style: TextStyle(
                                    color: GlobalStyles.lightGreyText)),
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
                                text: valueIsNull(
                                    bikeController.userBike.value.dateCreation),
                                style: TextStyle(
                                    color: GlobalStyles.lightGreyText)),
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
              onTap: () => Get.to(() => IncidentDeclaration(
                    client: bikeController.userBike.value.clientName,
                    velo: bikeController.userBike.value.bikeName,
                    groupe: bikeController.userBike.value.groupeName,
                    veloPk: bikeController.userBike.value.veloPk,
                  )),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: GlobalStyles.blue,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                  child: Text("Déclarer un incident",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600))),
            )),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Les incidents en cours",
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(height: 10.0),
            bikeController.userBike.value.inProgressRepairs.length == 0
                ? Center(
                    child: Text("Aucun incident en cours"),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                        itemCount: bikeController
                            .userBike.value.inProgressRepairs.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => {},
                            child: BuildIncidentHistoricTile(
                              data: bikeController
                                  .userBike.value.inProgressRepairs[index],
                              isHistorique: false,
                            ),
                          );
                        }),
                  ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Historique des incidents",
                          style: TextStyle(
                              color: GlobalStyles.purple,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600)),
                      GestureDetector(
                          onTap: () =>
                              bikeController.toggleIsBikeIncidentsOpen(),
                          child: Obx(() {
                            return Icon(
                                bikeController.isBikeIncidentsOpen.value
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: GlobalStyles.greyDropDown,
                                size: 30);
                          }))
                    ],
                  ),
                  AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                      child: Obx(() {
                        return Container(
                            height: bikeController.isBikeIncidentsOpen.value
                                ? null
                                : 0,
                            child: Column(
                              children: [
                                bikeController.userBike.value.otherRepairs
                                            .length ==
                                        0
                                    ? Text("Il y aura des éléments ici")
                                    : Column(
                                        children: [
                                          SizedBox(height: 20),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: bikeController.userBike
                                                  .value.otherRepairs.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                    onTap: () => null,
                                                    child:
                                                        BuildIncidentHistoricTile(
                                                      data: bikeController
                                                          .userBike
                                                          .value
                                                          .otherRepairs[index],
                                                      isHistorique: true,
                                                    ));
                                              }),
                                        ],
                                      )
                              ],
                            ));
                      }))
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 20, bottom: 50.0),
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
    ]);
  }
}

class BuildIncidentHistoricTile extends StatelessWidget {
  final Incident data;
  final bool isHistorique;

  const BuildIncidentHistoricTile(
      {Key? key, required this.data, required this.isHistorique})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.isHistorique
          ? const EdgeInsets.all(0.0)
          : const EdgeInsets.all(20.0),
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
                child: Text(valueIsNull(data.incidentTypeReparation),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 7.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(valueIsNull(data.dateCreation),
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
                    (data.interventionTime != 0
                            ? data.interventionTime.toString()
                            : "moins d'1") +
                        'h',
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )
            ],
          ),
          this.isHistorique
              ? Divider(
                  color: Colors.black,
                )
              : SizedBox()
        ],
      ),
    );
  }
}
