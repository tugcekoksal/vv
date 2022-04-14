// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/controllers/incident_declaration_controller.dart';

final IncidentDeclarationController incidentDeclarationController =
    Get.put(IncidentDeclarationController());

class BuildDisabledDropDown extends StatelessWidget {
  const BuildDisabledDropDown({Key? key, required this.placeholder})
      : super(key: key);

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          border:
              Border.all(color: GlobalStyles.backgroundLightGrey, width: 3.0),
          borderRadius: BorderRadius.circular(10.0),
          color: GlobalStyles.backgroundLightGrey),
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            placeholder,
            style: TextStyle(
                color: GlobalStyles.lightGreyText,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          placeholder == "Client"
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: GlobalStyles.greyDropDown,
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  Icons.arrow_drop_down,
                  color: GlobalStyles.greyDropDown,
                ),
        ],
      ),
    );
  }
}
