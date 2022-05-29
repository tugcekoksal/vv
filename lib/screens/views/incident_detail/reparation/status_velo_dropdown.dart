// Vendor
import 'package:flutter/material.dart';
import 'package:velyvelo/components/drop_down.dart';
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// GlobalKey keyWidget = GlobalKey();

class StatusVeloDropDown extends StatelessWidget {
  const StatusVeloDropDown({
    Key? key,
    required this.incidentController,
  }) : super(key: key);

  final IncidentController incidentController;

  @override
  Widget build(BuildContext context) {
    // Widget gotoWidget = SizedBox(height: 0, width: 0, key: keyWidget);

    return DropDown(
        placeholder: "Statut du vélo",
        dropdownItemList: incidentController.incidentDetailValue.value.status,
        setItem: incidentController.setBikeStatus);
    // ),
    // selectedItem: incidentController.currentReparation.value.statusBike,
    // items: incidentController.incidentDetailValue.value.status,
    // onChanged: (value) {
    //   incidentController.setBikeStatus(value);
    // }
  }
}
