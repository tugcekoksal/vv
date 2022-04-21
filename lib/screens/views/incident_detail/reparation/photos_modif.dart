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
                          child: Image.file(
                            incidentController.currentReparation.value
                                .reparationPhotosList[index],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: GlobalStyles.backgroundLightGreyLoading),
                        child: IconButton(
                          padding: EdgeInsets.all(0.0),
                          iconSize: 20,
                          icon: const Icon(Icons.delete),
                          onPressed: () => {
                            incidentController
                                .currentReparation.value.reparationPhotosList
                                .removeAt(index)
                          },
                        ),
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
