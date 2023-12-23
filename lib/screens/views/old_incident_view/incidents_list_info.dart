// Vendor
import 'package:flutter/material.dart';

// Components
import 'package:velyvelo/components/loading_box.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

class IncidentListError extends StatelessWidget {
  final IncidentController incidentController;

  const IncidentListError({super.key, required this.incidentController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0),
        child: GestureDetector(
          onTap: () => {
            incidentController.refreshIncidentsList(),
          },
          child: Column(children: [
            Image.asset("assets/incident_error.png"),
            const Icon(Icons.refresh),
            const Text("Recharger")
          ]),
        ),
      ),
    ));
  }
}

class IncidentListEmpty extends StatelessWidget {
  final IncidentController incidentController;

  const IncidentListEmpty({super.key, required this.incidentController});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_box_rounded,
              color: global_styles.green,
              size: 50,
            ),
            Text(
              "Aucun incidents",
              style: TextStyle(
                  color: global_styles.backgroundDarkGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class ListIncidentIsLoading extends StatelessWidget {
  const ListIncidentIsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return LoadingBox(
                child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(
                        bottom: 8.0, left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    height: 100),
              );
            }));
  }
}
