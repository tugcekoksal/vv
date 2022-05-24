// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_declaration_controller.dart';

class DisabledDropDown extends StatelessWidget {
  DisabledDropDown({Key? key, required this.placeholder}) : super(key: key);

  final String placeholder;
  final IncidentDeclarationController incidentDeclarationController =
      Get.put(IncidentDeclarationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          border:
              Border.all(color: global_styles.backgroundLightGrey, width: 3.0),
          borderRadius: BorderRadius.circular(10.0),
          color: global_styles.backgroundLightGrey),
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            placeholder,
            style: const TextStyle(
                color: global_styles.lightGreyText,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          placeholder == "Client"
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: global_styles.greyDropDown,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.arrow_drop_down,
                  color: global_styles.greyDropDown,
                ),
        ],
      ),
    );
  }
}
