// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/screens/views/incident_detail/reparation/pick_image.dart';

// Components
import 'package:velyvelo/components/slider_show_full_images.dart';

class PhotosModif extends StatelessWidget {
  final IncidentController incidentController;

  const PhotosModif({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Photos",
          style: TextStyle(
              color: global_styles.purple,
              fontSize: 17.0,
              fontWeight: FontWeight.w600)),
      const SizedBox(height: 10.0),
      Obx(() {
        if (incidentController
            .currentReparation.value.reparationPhotosList.isEmpty) {
          return PickImage(
            setItem: incidentController.setReparationsPhotosValue,
            text: "Prendre une photo",
          );
        } else {
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0),
              physics: const NeverScrollableScrollPhysics(),
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
                    setItem: incidentController.setReparationsPhotosValue,
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
                                  builder: (context) => SliderShowFullImages(
                                      mode: "File",
                                      listImagesModel: incidentController
                                          .currentReparation
                                          .value
                                          .reparationPhotosList,
                                      current: 0)));
                            },
                            child: Stack(children: [
                              SizedBox(
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
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0)),
                                      color:
                                          Color.fromARGB(129, 228, 229, 232)),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0.0),
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
