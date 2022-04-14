// Vendor
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velyvelo/components/BuildDropDown.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Components
import 'package:velyvelo/components/BuildDisabledDropDown.dart';
import 'package:velyvelo/components/BuildShowImageFullSlider.dart';

// Controllers
import 'package:velyvelo/controllers/incident_declaration_controller.dart';

class BuildFormIncident extends StatefulWidget {
  BuildFormIncident({
    Key? key,
    required this.indexIncident,
  }) : super(key: key);

  final int indexIncident;

  @override
  State<BuildFormIncident> createState() => _BuildFormIncidentState();
}

class _BuildFormIncidentState extends State<BuildFormIncident> {
  final indexKey = new GlobalKey();

  final IncidentDeclarationController incidentDeclarationController =
      Get.put(IncidentDeclarationController());

  Future pickImage() async {
    try {
      final _currentImage = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 500,
          maxWidth: 500);
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
              duration: Duration(seconds: 1),
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
                        margin: EdgeInsets.only(left: 5.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            color: GlobalStyles.backgroundDarkGrey,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Icon(Icons.remove, color: Colors.white)),
                  )
                : SizedBox()
          ],
        ),
        Obx(() {
          if (incidentDeclarationController.isLoadingLabelIncidentType.value) {
            return BuildDisabledDropDown(placeholder: "Type d'incident");
          } else {
            return BuildDropDown(
              placeholder: "Type d'incident",
              dropdownItemList:
                  incidentDeclarationController.dropDownItemIncidentTypeList,
              setItem: incidentDeclarationController.setIncidentTypeLabel,
              index: widget.indexIncident,
            );
          }
        }),
        Obx(() {
          if (incidentDeclarationController
                  .indexWhereFormIsNotCompleted.value ==
              widget.indexIncident.toString()) {
            return Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Le champ doit être spécifié",
                    style: TextStyle(
                        color: GlobalStyles.orange,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500)),
              ),
            );
          } else {
            return SizedBox();
          }
        }),
        SizedBox(height: 10.0),
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
                  borderSide: BorderSide(
                      color: GlobalStyles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: GlobalStyles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: GlobalStyles.backgroundLightGrey, width: 4.0),
                  borderRadius: BorderRadius.circular(15.0)),
              hintStyle: TextStyle(
                  color: GlobalStyles.greyTextInput,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
              hintText: "Commentaire"),
          style: TextStyle(
              color: GlobalStyles.greyTextInput,
              fontSize: 16.0,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.0),
        Obx(() {
          if (incidentDeclarationController
                  .incidentPhotosList[widget.indexIncident].length ==
              0) {
            return GestureDetector(
              onTap: () => pickImage(),
              child: DottedBorder(
                color: GlobalStyles.backgroundLightGrey,
                strokeWidth: 4,
                radius: Radius.circular(40.0),
                dashPattern: [15, 15],
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          color: GlobalStyles.greyTextInput, size: 50.0),
                      SizedBox(height: 10.0),
                      Text("Prendre une photo",
                          style: TextStyle(
                              color: GlobalStyles.greyTextInput,
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
                physics: NeverScrollableScrollPhysics(),
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
                              color: GlobalStyles.backgroundLightGrey,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              Icon(Icons.add,
                                  color: GlobalStyles.greyTextInput,
                                  size: 35.0),
                              Text(
                                "Ajouter d'autres photos",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: GlobalStyles.greyTextInput,
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
                        // child: Image.memory(base64.decode(incidentDeclarationController.incidentPhotosList[indexIncident][index]),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SliderShowFullmages(
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
                            // height: 50
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
