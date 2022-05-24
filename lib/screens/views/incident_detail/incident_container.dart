// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

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
          const Text("Incident(s)",
              style: TextStyle(
                  color: global_styles.purple,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10.0),
          Obx(() {
            return RichText(
              text: TextSpan(
                text: "Type d'incident ",
                style: const TextStyle(
                    color: global_styles.greyText,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700),
                children: <TextSpan>[
                  TextSpan(
                      text: incidentController.actualTypeReparation.value,
                      style:
                          const TextStyle(color: global_styles.lightGreyText)),
                ],
              ),
            );
          }),
          const SizedBox(height: 5.0),
          incidentController.incidentDetailValue.value.commentaire == null
              ? const SizedBox()
              : RichText(
                  text: TextSpan(
                    text: 'Commentaire associé : ',
                    style: const TextStyle(
                        color: global_styles.greyText,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                    children: <TextSpan>[
                      TextSpan(
                          text: incidentController
                              .incidentDetailValue.value.commentaire,
                          style: const TextStyle(
                              color: global_styles.lightGreyText)),
                    ],
                  ),
                ),
          const SizedBox(height: 5.0),
          RichText(
            text: const TextSpan(
                text: 'Photos ',
                style: TextStyle(
                    color: global_styles.greyText,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 10),
          incidentController.incidentDetailValue.value.photos == null ||
                  incidentController.incidentDetailValue.value.photos!.isEmpty
              ? const Text(
                  "Cet incident ne contient aucune photo",
                  style: TextStyle(
                      color: global_styles.lightGreyText,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                )
              : GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
