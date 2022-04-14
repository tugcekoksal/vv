// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Components
import 'package:velyvelo/components/BuildDropDown.dart';
import 'package:velyvelo/components/BuildFormIncident.dart';
import 'package:velyvelo/components/BuildFormsDivider.dart';
import 'package:velyvelo/components/BuildDisabledDropDown.dart';

// Controllers
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/controllers/incident_controller.dart';

class IncidentDeclaration extends StatefulWidget {
  final String? client;
  final String? groupe;
  final String? velo;
  final int? veloPk;

  IncidentDeclaration(
      {Key? key, this.client, this.groupe, this.velo, this.veloPk})
      : super(key: key);

  @override
  State<IncidentDeclaration> createState() => _IncidentDeclarationState();
}

class _IncidentDeclarationState extends State<IncidentDeclaration> {
  final IncidentDeclarationController incidentDeclarationController =
      Get.put(IncidentDeclarationController());

  final LoginController loginController = Get.put(LoginController());

  final IncidentController incidentController = Get.put(IncidentController());

  showIncidentSendingFeedback(context, text, color) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Icon(
            Icons.info_rounded,
            color: Colors.white,
          )
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalStyles.backgroundLightGrey,
      appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 65.0,
          elevation: 0,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          title: Text(
            "Mes incidents",
            style: TextStyle(
                color: GlobalStyles.greyTitle,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 15.0),
            child: SvgPicture.asset("assets/logo.svg",
                height: 15.0, width: 15.0, fit: BoxFit.scaleDown),
          )),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
                    child: Stack(alignment: Alignment.center, children: [
                      Text("Déclaration d'incident(s)",
                          style: TextStyle(
                              color: GlobalStyles.greyText,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w700)),
                      Positioned(
                          left: 25.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              incidentDeclarationController.deleteAllForms();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20.0,
                            ),
                          ))
                    ])),
                SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informations",
                        style: TextStyle(
                            color: GlobalStyles.greyText,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.0),
                      Obx(() {
                        if (this.widget.client != null)
                          incidentDeclarationController.informations["Client"] =
                              this.widget.client!;
                        if (incidentDeclarationController
                                .isLoadingLabelClient.value &&
                            loginController.isAdminOrTech.value) {
                          return BuildDisabledDropDown(placeholder: "Client");
                        } else if (loginController.isAdminOrTech.value) {
                          return BuildDropDown(
                              placeholder: this.widget.client != null
                                  ? this.widget.client!
                                  : "Client",
                              dropdownItemList: incidentDeclarationController
                                  .dropdownItemClientListNames,
                              setItem:
                                  incidentDeclarationController.setClientLabel);
                        } else {
                          return SizedBox();
                        }
                      }),
                      SizedBox(height: 10.0),
                      Obx(() {
                        if (incidentDeclarationController
                                    .clientLabelPicked.value &&
                                !loginController.isUser.value ||
                            this.widget.velo != null) {
                          return BuildDropDown(
                              placeholder: this.widget.groupe != null
                                  ? this.widget.groupe!
                                  : "Groupe",
                              dropdownItemList: incidentDeclarationController
                                  .dropdownItemGroupListNames,
                              setItem:
                                  incidentDeclarationController.setGroupLabel);
                        } else if (loginController.isUser.value) {
                          return SizedBox();
                        } else {
                          return BuildDisabledDropDown(placeholder: "Groupe");
                        }
                      }),
                      SizedBox(height: 10.0),
                      Obx(() {
                        if (incidentDeclarationController
                                .groupLabelPicked.value ||
                            loginController.isUser.value ||
                            this.widget.velo != null) {
                          return BuildDropDown(
                              placeholder: this.widget.velo != null
                                  ? this.widget.velo!
                                  : "Vélo",
                              dropdownItemList: incidentDeclarationController
                                  .dropdownItemBikeListNames,
                              setItem:
                                  incidentDeclarationController.setBikeLabel);
                        } else {
                          return BuildDisabledDropDown(placeholder: "Vélo");
                        }
                      }),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Incident(s)",
                        style: TextStyle(
                            color: GlobalStyles.greyText,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.0),
                      BuildFormIncident(indexIncident: 0),
                      Obx(() {
                        if (incidentDeclarationController
                                .incidentMoreFormsList.length >
                            0) {
                          return BuildFormsDivider();
                        } else {
                          return SizedBox();
                        }
                      }),
                      Obx(() => ListView.separated(
                            itemCount: incidentDeclarationController
                                .incidentMoreFormsList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return BuildFormIncident(
                                    indexIncident: incidentDeclarationController
                                        .incidentMoreFormsList[index]);
                              });
                            },
                            separatorBuilder: (context, index) =>
                                BuildFormsDivider(),
                          )),
                      SizedBox(height: 25.0),
                      Center(
                        child: GestureDetector(
                          onTap: () => incidentDeclarationController.addForm(),
                          child: Container(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 15, 15, 15),
                              decoration: BoxDecoration(
                                  color: GlobalStyles.backgroundDarkGrey,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Icon(Icons.add, color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Center(
                        child: Text("Ajouter un autre incident à déclarer",
                            style: TextStyle(
                                color: GlobalStyles.greyTextInput,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            await incidentDeclarationController
                                .sendIncident(this.widget.veloPk);
                            if (incidentDeclarationController
                                    .isFormUncompleted.value !=
                                "") {
                              print(
                                  "error value ${incidentDeclarationController.isFormUncompleted.value}");
                              showIncidentSendingFeedback(
                                  context,
                                  incidentDeclarationController
                                      .isFormUncompleted.value,
                                  GlobalStyles.orange);
                            } else {
                              showIncidentSendingFeedback(
                                  context,
                                  "Vos incidents ont été ajouté avec succès.",
                                  GlobalStyles.green);
                              Future.delayed(Duration(milliseconds: 200),
                                  () => Navigator.of(context).pop());
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: GlobalStyles.blue,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 12.0),
                            child: Text("Valider ma déclaration",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
