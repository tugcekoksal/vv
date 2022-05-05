// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/screens/views/incident_detail/reparation/pick_image.dart';

// Components
import 'package:velyvelo/components/BuildShowImageFullSlider.dart';

class PhotosModif extends StatelessWidget {
  final IncidentController incidentController;

  const PhotosModif({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Photos",
          style: TextStyle(
              color: GlobalStyles.purple,
              fontSize: 17.0,
              fontWeight: FontWeight.w600)),
      SizedBox(height: 10.0),
      Obx(() {
        if (incidentController
                .currentReparation.value.reparationPhotosList.length ==
            0) {
          return PickImage(
            incidentController: incidentController,
            text: "Prendre une photo",
          );
        } else {
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: incidentController
                      .currentReparation.value.reparationPhotosList.length +
                  1,
              itemBuilder: (BuildContext context, int index) {
                // Last element
                if (incidentController
                        .currentReparation.value.reparationPhotosList.length ==
                    index) {
                  return PickImage(
                    incidentController: incidentController,
                    text: "Ajouter d'autres photos",
                  );
                } else {
                  return Obx(() {
                    return Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SliderShowFullmages(
                                      mode: "File",
                                      listImagesModel: incidentController
                                          .currentReparation
                                          .value
                                          .reparationPhotosList,
                                      current: 0)));
                            },
                            child: Stack(children: [
                              Container(
                                  width: 100,
                                  height: 75,
                                  child: Image.file(
                                    incidentController.currentReparation.value
                                        .reparationPhotosList[index],
                                    fit: BoxFit.cover,
                                  )),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0)),
                                      color:
                                          Color.fromARGB(129, 228, 229, 232)),
                                  child: IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    iconSize: 20,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => {
                                      incidentController.currentReparation.value
                                          .reparationPhotosList
                                          .removeAt(index),
                                      incidentController.currentReparation
                                          .refresh(),
                                    },
                                  ),
                                ),
                              )
                            ])),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                    ]);
                  });
                }
              });
        }
      })
    ]);
  }
}
