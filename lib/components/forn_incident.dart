// Vendor
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velyvelo/components/drop_down.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Components
import 'package:velyvelo/components/disabled_drop_down.dart';
import 'package:velyvelo/components/slider_show_full_images.dart';

// Controllers
import 'package:velyvelo/controllers/incident_declaration_controller.dart';

class BuildFormIncident extends StatefulWidget {
  const BuildFormIncident({
    Key? key,
    required this.indexIncident,
  }) : super(key: key);

  final int indexIncident;

  @override
  State<BuildFormIncident> createState() => _BuildFormIncidentState();
}

class _BuildFormIncidentState extends State<BuildFormIncident> {
  final indexKey = GlobalKey();

  final IncidentDeclarationController incidentDeclarationController =
      Get.put(IncidentDeclarationController());

  Future pickImage() async {
    try {
      showDialog(
          barrierColor: Colors.transparent,
          barrierDismissible: false,
          // useSafeArea: true,

          context: context,
          builder: (BuildContext context) {
            return Center(
              child:
                  Container(height: 300, width: 300, color: Colors.transparent),
            );
          });
      final _currentImage = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 500,
          maxWidth: 500);
      Navigator.pop(context);
      if (_currentImage == null) return;

      final imageTemporary = File(_currentImage.path);

      incidentDeclarationController.setIncidentPhotosValue(
          imageTemporary, widget.indexIncident);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    incidentDeclarationController.indexWhereFormIsNotCompleted.listen((index) {
      // Listen to the changes of which index is not completed and then srolls towards it
      if (index == widget.indexIncident.toString()) {
        if (indexKey.currentContext != null) {
          Scrollable.ensureVisible(indexKey.currentContext!,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              alignmentPolicy:
                  ScrollPositionAlignmentPolicy.keepVisibleAtStart);
        }
      }
    });

    return Column(
      key: indexKey,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.indexIncident ==
                        incidentDeclarationController
                            .incidentMoreFormsList.length &&
                    widget.indexIncident != 0
                ? GestureDetector(
                    onTap: () => incidentDeclarationController
                        .deleteForm(widget.indexIncident),
                    child: Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        margin: const EdgeInsets.only(left: 5.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            color: global_styles.backgroundDarkGrey,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Icon(Icons.remove, color: Colors.white)),
                  )
                : const SizedBox()
          ],
        ),
        Obx(() {
          if (incidentDeclarationController
              .incidentTypeSelection.value.isLoading) {
            return DisabledDropDown(placeholder: "Type d'incident");
          } else {
            return DropDown(
              placeholder: "Type d'incident",
              dropdownItemList: incidentDeclarationController
                  .incidentTypeSelection.value.listOptions
                  .map((e) => e.name)
                  .toList(),
              setItem: incidentDeclarationController.setIncidentTypeLabel,
              index: widget.indexIncident,
            );
          }
        }),
        Obx(() {
          if (incidentDeclarationController.isFormUncompleted.value != "") {
            return const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Le type d'incident n'est pas renseigné",
                    style: TextStyle(
                        color: global_styles.orange,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500)),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
        const SizedBox(height: 10.0),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          autofocus: false,
          minLines: 5,
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          onChanged: (e) => incidentDeclarationController
              .setIncidentCommentValue(e, widget.indexIncident),
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: global_styles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: global_styles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: global_styles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
              hintStyle: const TextStyle(
                  color: global_styles.greyTextInput,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
              hintText: "Commentaire"),
          style: const TextStyle(
              color: global_styles.greyTextInput,
              fontSize: 16.0,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10.0),
        Obx(() {
          if (incidentDeclarationController
              .incidentPhotosList[widget.indexIncident].isEmpty) {
            return GestureDetector(
              onTap: () => pickImage(),
              child: DottedBorder(
                color: global_styles.backgroundLightGrey,
                strokeWidth: 4,
                radius: const Radius.circular(40.0),
                dashPattern: const [15, 15],
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.camera_alt_outlined,
                          color: global_styles.greyTextInput, size: 50.0),
                      SizedBox(height: 10.0),
                      Text("Prendre une photo",
                          style: TextStyle(
                              color: global_styles.greyTextInput,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                ),
              ),
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
                itemCount: incidentDeclarationController
                        .incidentPhotosList[widget.indexIncident].length +
                    1,
                itemBuilder: (BuildContext context, int index) {
                  // Last element
                  if (incidentDeclarationController
                          .incidentPhotosList[widget.indexIncident].length ==
                      index) {
                    return GestureDetector(
                        onTap: () => pickImage(),
                        child: Container(
                          decoration: BoxDecoration(
                              color: global_styles.backgroundLightGrey,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(height: 20),
                              Icon(Icons.add,
                                  color: global_styles.greyTextInput,
                                  size: 35.0),
                              Text(
                                "Ajouter d'autres photos",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: global_styles.greyTextInput,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ));
                  } else {
                    return Obx(() {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SliderShowFullImages(
                                    mode: "File",
                                    listImagesModel:
                                        incidentDeclarationController
                                                .incidentPhotosList[
                                            widget.indexIncident],
                                    current: incidentDeclarationController
                                        .currentImageIndexInViewer.value)));
                          },
                          child: Image.file(
                            incidentDeclarationController
                                    .incidentPhotosList[widget.indexIncident]
                                [index],
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      );
                    });
                  }
                });
          }
        }),
      ],
    );
  }
}
