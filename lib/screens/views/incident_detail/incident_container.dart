// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/BuildDropDown.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

// Service Url
import 'package:velyvelo/services/http_service.dart';

// Components
import 'package:velyvelo/components/BuildShowImageFullSlider.dart';

class IncidentContainer extends StatelessWidget {
  final IncidentController incidentController;

  const IncidentContainer({Key? key, required this.incidentController})
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
          Text("Incident(s)",
              style: TextStyle(
                  color: GlobalStyles.purple,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10.0),
          Obx(() {
            return RichText(
              text: TextSpan(
                text: "Type d'incident ",
                style: TextStyle(
                    color: GlobalStyles.greyText,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700),
                children: <TextSpan>[
                  TextSpan(
                      text: incidentController.selectedIncidentType.value == ""
                          ? valueIsNull(incidentController
                              .incidentDetailValue.value.typeIncident)
                          : incidentController.selectedIncidentType.value,
                      style: TextStyle(color: GlobalStyles.lightGreyText)),
                  TextSpan(
                    text: incidentController.modifTypeIncident.value
                        ? ' fermer'
                        : ' modifier',
                    style: TextStyle(color: GlobalStyles.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        incidentController.typeIncidentAction();
                      },
                  ),
                ],
              ),
            );
          }),
          Obx(() {
            if (incidentController.modifTypeIncident.value)
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: BuildDropDown(
                      placeholder:
                          incidentController.selectedIncidentType.value == ""
                              ? "Type d'incident"
                              : incidentController.selectedIncidentType.value,
                      dropdownItemList:
                          incidentController.dropDownItemIncidentTypeList,
                      setItem: (value, index) => {
                            incidentController.setItemIncidentType(
                                value, index),
                            incidentController.modifTypeIncident.value = false
                          },
                      index: 0
                      // widget.indexIncident,
                      ));
            return SizedBox(height: 0, width: 0);
          }),
          SizedBox(height: 5.0),
          incidentController.incidentDetailValue.value.commentaire == null
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
                              .incidentDetailValue.value.commentaire,
                          style: TextStyle(color: GlobalStyles.lightGreyText)),
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
          incidentController.incidentDetailValue.value.photos == null ||
                  incidentController.incidentDetailValue.value.photos!.length ==
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
                              .incidentDetailValue.value.photos ==
                          null
                      ? <String>[]
                          .map((e) => ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SliderShowFullmages(
                                          mode: "Network",
                                          listImagesModel: incidentController
                                              .incidentDetailValue
                                              .value
                                              .photos!,
                                          current: incidentController
                                              .currentImageIndexInViewer
                                              .value)));
                                },
                                child: Image.asset(
                                  e,
                                  fit: BoxFit.fitWidth,
                                ),
                              )))
                          .toList()
                      : incidentController.incidentDetailValue.value.photos!
                          .map((image) => ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SliderShowFullmages(
                                                    mode: "Network",
                                                    listImagesModel:
                                                        incidentController
                                                            .incidentDetailValue
                                                            .value
                                                            .photos!,
                                                    current: 0)));
                                  },
                                  child: Image.network(
                                    HttpService.urlServer + image,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ))
                          .toList(),
                )
        ],
      ),
    );
  }
}