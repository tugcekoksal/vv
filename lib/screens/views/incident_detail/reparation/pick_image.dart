import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/helpers/logger.dart';

class PickImage extends StatelessWidget {
  final Function setItem;
  final String text;
  final log = logger(PickImage);

  PickImage({super.key, required this.setItem, required this.text});

  Future<File?> pickImage(context) async {
    try {
      showDialog(
          barrierColor: Colors.black45,
          barrierDismissible: false,
          useRootNavigator: false, //this property needs to be added
          context: context,
          builder: (BuildContext context) {
            return Center(
              child:
                  Container(height: 300, width: 300, color: Colors.transparent),
            );
          });
      final currentImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80);
      Navigator.pop(context);
      if (currentImage == null) return null;

      final imageTemporary = File(currentImage.path);
      return imageTemporary;
    } catch (e) {
      log.e(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pickImage(context).then((newImage) {
          if (newImage != null) {
            setItem(newImage);
          }
        });
      },
      child: DottedBorder(
        color: global_styles.backgroundLightGrey,
        strokeWidth: 3,
        radius: const Radius.circular(40.0),
        dashPattern: const [15, 15],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: const Column(
            children: [
              Icon(Icons.camera_alt_outlined,
                  color: global_styles.greyTextInput, size: 25.0),
              SizedBox(height: 10.0),
              Text("Prendre une photo",
                  style: TextStyle(
                      color: global_styles.greyTextInput,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w700))
            ],
          ),
        ),
      ),
    );
  }
}
