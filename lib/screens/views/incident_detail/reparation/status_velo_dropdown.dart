// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/drop_down.dart';
import 'package:velyvelo/controllers/incident_controller.dart';

class StatusVeloDropDown extends StatelessWidget {
  const StatusVeloDropDown({
    Key? key,
    required this.incidentController,
  }) : super(key: key);

  final IncidentController incidentController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropDown(
          placeholder: incidentController.currentReparation.value.statusBike ??
              "Erreur status",
          dropdownItemList: incidentController.incidentDetailValue.value.status,
          setItem: incidentController.setBikeStatus);
    });
  }
}
