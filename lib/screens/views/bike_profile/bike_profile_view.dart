// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/bike_provider/bike_profile_provider.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';

// Helpers
import 'package:velyvelo/models/bike/user_bike_model.dart';
import 'package:velyvelo/models/json_usefull.dart';
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_in_progress.dart';
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

// Views
import 'package:velyvelo/screens/views/incident_declaration/incident_declaration_view.dart';

// Components
import 'package:velyvelo/components/loading_box.dart';
import 'package:velyvelo/screens/views/bike_profile/incident_history/incident_history_container.dart';

// Service Url
import 'package:velyvelo/services/http_service.dart';
import 'package:flutter/cupertino.dart';

DeclarationInfoContainer infoDeclarationFromBikeController(
    UserBikeModel userBike) {
  final IncidentDeclarationController declarationController =
      Get.put(IncidentDeclarationController());
  // Fill global infos
  declarationController.infosSelection.update((val) => {
        val?.infoClient.selected = IdAndName(id: 0, name: userBike.clientName),
        val?.infoGroup.selected = IdAndName(id: 0, name: userBike.groupeName),
        val?.infoVelo.selected =
            IdAndName(id: userBike.veloPk, name: userBike.bikeName)
      });

  // Give the infos to dropdown
  return DeclarationInfoContainer(
      client: IdAndName(id: 0, name: userBike.clientName),
      group: IdAndName(id: 0, name: userBike.groupeName),
      velo: IdAndName(id: userBike.veloPk, name: userBike.bikeName));
}

void showConfirmStolenBikeDialog(
    BuildContext context, BikeProfileProvider bikeProfile) {
  BuildContext savePageContext = context;
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: bikeProfile.userBike.isStolen
            ? const Text("Vélo retrouvé ?")
            : const Text("Déclarer un vol"),
        content: bikeProfile.userBike.isStolen
            ? const Text(
                "Êtes-vous sûr de vouloir déclarer votre vélo comme retrouvé ?")
            : const Text(
                "Êtes-vous sûr de vouloir déclarer votre vélo comme volé ?"),
        actions: [
          CupertinoDialogAction(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          CupertinoDialogAction(
            child: const Text("Confirmer"),
            onPressed: () async {
              bikeProfile.userBike.isStolen = !bikeProfile.userBike.isStolen;
              Navigator.of(context).pop();

              await bikeProfile.setBikeToNewRobbedStatus(
                  bikeProfile.userBike.isStolen, bikeProfile.userBike.veloPk);
              final snackBar = SnackBar(
                content: Text('Votre vélo a bien été déclaré comme ' +
                    (bikeProfile.userBike.isStolen ? 'volé !' : 'retrouvé !')),
                backgroundColor: const Color(0xff46b594),
              );

              // Find the Scaffold in the widget tree and use
              // it to show a SnackBar.

              ScaffoldMessenger.of(savePageContext).showSnackBar(snackBar);
              // didChangeDependencies();
            },
          )
        ],
      );
    },
  );
}

class MyBikeView extends ConsumerWidget {
  final bool isFromScan;
  final int veloPk;

  MyBikeView({Key? key, required this.isFromScan, this.veloPk = 0})
      : super(key: key);

  final IncidentDeclarationController declarationController =
      Get.put(IncidentDeclarationController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    final BikeProfileProvider bikeProfile = ref.watch(bikeProfileProvider);
    Future(() {
      if (!isFromScan) {
        bikeProfile.fetchUserBike(veloPk);
      }
      // bikeProfile.isViewingScanPage = false;
      // ref.read(qrCodeProvider).setCanScan(true);
    });

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: global_styles.backgroundLightGrey,
        body: ColorfulSafeArea(
            color: Colors.white,
            child: Stack(children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 85, 0, 60),
                  child: Column(
                    children: [
                      bikeProfile.isLoading
                          ? LoadingBox(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 20.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8.0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                height: screenHeight * 0.25,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Image.network(
                                bikeProfile.userBike.pictureUrl != ""
                                    ? HttpService.urlServer +
                                        bikeProfile.userBike.pictureUrl
                                    : "https://velyvelo.com/static/vitrine/gif/hp_cycliste_coursier.gif",
                                height: screenHeight * 0.15,
                              ),
                            ),
                      const SizedBox(height: 10.0),
                      // If the bike view is loading
                      bikeProfile.isLoading
                          ? LoadingBox(
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
                            )
                          // If the there is an error laoding the bike view
                          : bikeProfile.messageError != ''
                              ? Center(
                                  child: Text(bikeProfile.messageError,
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)))
                              // If bike views datas area well loaded
                              : Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 20.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Informations",
                                          style: TextStyle(
                                              color: global_styles.purple,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 5.0),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Groupe ',
                                          style: const TextStyle(
                                              color: global_styles.greyText,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: bikeProfile
                                                    .userBike.groupeName,
                                                style: const TextStyle(
                                                    color: global_styles
                                                        .lightGreyText)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Kilométrage ',
                                          style: const TextStyle(
                                              color: global_styles.greyText,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: bikeProfile
                                                    .userBike.kilometrage
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: global_styles
                                                        .lightGreyText)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Client ',
                                          style: const TextStyle(
                                              color: global_styles.greyText,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: bikeProfile
                                                    .userBike.clientName,
                                                style: const TextStyle(
                                                    color: global_styles
                                                        .lightGreyText)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Numéro Cadre ',
                                          style: const TextStyle(
                                              color: global_styles.greyText,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: bikeProfile
                                                    .userBike.numeroCadran,
                                                style: const TextStyle(
                                                    color: global_styles
                                                        .lightGreyText)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Date de création ',
                                          style: const TextStyle(
                                              color: global_styles.greyText,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: bikeProfile
                                                    .userBike.dateCreation,
                                                style: const TextStyle(
                                                    color: global_styles
                                                        .lightGreyText)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                      const SizedBox(height: 20.0),
                      Center(
                          child: GestureDetector(
                        onTap: () => Get.to(
                            // Préremplir les champs
                            () => IncidentDeclaration(
                                infoContainer:
                                    infoDeclarationFromBikeController(ref
                                        .read(bikeProfileProvider)
                                        .userBike)),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 400)),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: global_styles.blue,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 15.0),
                            child: const Text("Déclarer un incident",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600))),
                      )),
                      const SizedBox(height: 20.0),
                      // Display title & list of current incidents
                      const IncidentInProgress(),
                      const SizedBox(height: 10.0),
                      // Button & list of passed incidents
                      const IncidentHistoryContainer(),
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
                              children: const [
                                Text("Que faire en cas de vol ?",
                                    style: TextStyle(
                                        color: global_styles.purple,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 10.0),
                                Text(
                                    "Votre vélo a été volé ? Déclarez-le sur l'application à l'aide du bouton ci-dessous",
                                    style: TextStyle(
                                        color: global_styles.purple,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ),
                          Positioned(
                            child: GestureDetector(
                              onTap: () => showConfirmStolenBikeDialog(
                                  context, ref.read(bikeProfileProvider)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: bikeProfile.userBike.isStolen
                                      ? const Color(0xff46b594)
                                      : global_styles.orange,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 18.0),
                                child: Text(
                                    bikeProfile.userBike.isStolen
                                        ? "Mon vélo a été retrouvé"
                                        : "Déclarer mon vélo comme volé",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Return Bar
              (!isFromScan
                  ? ReturnBar(text: bikeProfile.userBike.bikeName)
                  : ReturnBarScan(text: bikeProfile.userBike.bikeName))
            ])));
  }
}
