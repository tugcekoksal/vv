import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_controller.dart';

class PickImage extends StatelessWidget {
  final IncidentController incidentController;
  final String text;

  PickImage({Key? key, required this.incidentController, required this.text})
      : super(key: key);

  Future pickImage(context) async {
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

      incidentController.setReparationsPhotosValue(imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {pickImage(context)},
      child: DottedBorder(
        color: GlobalStyles.backgroundLightGrey,
        strokeWidth: 3,
        radius: Radius.circular(40.0),
        dashPattern: [15, 15],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Icon(Icons.camera_alt_outlined,
                  color: GlobalStyles.greyTextInput, size: 25.0),
              SizedBox(height: 10.0),
              Text("Prendre une photo",
                  style: TextStyle(
                      color: GlobalStyles.greyTextInput,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w700))
            ],
          ),
        ),
      ),
    );
  }
}
