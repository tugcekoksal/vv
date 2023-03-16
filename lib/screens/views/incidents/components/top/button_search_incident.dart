import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

class ButtonSearchIncident extends StatelessWidget {
  final IncidentController incidentController;

  const ButtonSearchIncident({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(children: [
        TopButton(
            actionFunction: () => {
                  print("CLIQUE"),
                  incidentController.displaySearch.value = true
                },
            isLoading: false,
            iconButton: Icons.search),
        incidentController.searchText.value == ""
            ? const SizedBox(height: 0, width: 0)
            : Positioned(
                right: 3,
                top: 3,
                child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: global_styles.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.warning,
                      color: Colors.white,
                      size: 10,
                    )))
      ]);
    });
  }
}
