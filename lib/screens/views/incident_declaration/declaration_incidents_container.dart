import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/forn_incident.dart';
import 'package:velyvelo/components/forms_divider.dart';
import 'package:velyvelo/controllers/incident_declaration_controller.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;

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
          const Icon(
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
          const Text(
            "Incident(s)",
            style: TextStyle(
                color: global_styles.greyText,
                fontSize: 19.0,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10.0),
          const BuildFormIncident(indexIncident: 0),
          Obx(() {
            if (declarationController.incidentMoreFormsList.isNotEmpty) {
              return const FormsDivider();
            } else {
              return const SizedBox();
            }
          }),
          Obx(() => ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: declarationController.incidentMoreFormsList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Obx(() {
                    return BuildFormIncident(
                        indexIncident:
                            declarationController.incidentMoreFormsList[index]);
                  });
                },
                separatorBuilder: (context, index) => const FormsDivider(),
              )),
          const SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTap: () => declarationController.addForm(),
              child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                  decoration: BoxDecoration(
                      color: global_styles.backgroundDarkGrey,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 15.0),
          const Center(
            child: Text("Ajouter un autre incident à déclarer",
                style: TextStyle(
                    color: global_styles.greyTextInput,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
