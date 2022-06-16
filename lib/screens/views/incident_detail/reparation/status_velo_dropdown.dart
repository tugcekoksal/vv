// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/disabled_drop_down.dart';
import 'package:velyvelo/components/drop_down.dart';
import 'package:velyvelo/controllers/incident_controller.dart';

class StatusVeloDropDown extends StatelessWidget {
  final bool disabled;

  const StatusVeloDropDown(
      {Key? key, required this.incidentController, required this.disabled})
      : super(key: key);

  final IncidentController incidentController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (disabled) {
        return DisabledDropDown(
            placeholder:
                incidentController.currentReparation.value.statusBike ??
                    "Erreur status");
      } else {
        return DropDown(
            placeholder:
                incidentController.currentReparation.value.statusBike ??
                    "Erreur status",
            dropdownItemList:
                incidentController.incidentDetailValue.value.status,
            setItem: incidentController.setBikeStatus);
      }
    });
  }
}
