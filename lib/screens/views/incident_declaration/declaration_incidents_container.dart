import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/BuildFormIncident.dart';
import 'package:velyvelo/components/BuildFormsDivider.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class DeclarationIncidentsContainer extends StatelessWidget {
  final IncidentDeclarationController declarationController =
      Get.put(IncidentDeclarationController());

  DeclarationIncidentsContainer({Key? key}) : super(key: key);

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
    return Container(
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
            if (declarationController.incidentMoreFormsList.length > 0) {
              return BuildFormsDivider();
            } else {
              return SizedBox();
            }
          }),
          Obx(() => ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: declarationController.incidentMoreFormsList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Obx(() {
                    return BuildFormIncident(
                        indexIncident:
                            declarationController.incidentMoreFormsList[index]);
                  });
                },
                separatorBuilder: (context, index) => BuildFormsDivider(),
              )),
          const SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTap: () => declarationController.addForm(),
              child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
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
        ],
      ),
    );
  }
}
