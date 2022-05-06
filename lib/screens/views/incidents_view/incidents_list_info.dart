// Vendor
import 'package:flutter/material.dart';

// Components
import 'package:velyvelo/components/BuildLoadingBox.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class IncidentListError extends StatelessWidget {
  final IncidentController incidentController;

  const IncidentListError({Key? key, required this.incidentController})
      : super(key: key);

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
            Icon(Icons.refresh),
            Text("Recharger")
          ]),
        ),
      ),
    ));
  }
}

class IncidentListEmpty extends StatelessWidget {
  final IncidentController incidentController;

  const IncidentListEmpty({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_box_rounded,
              color: GlobalStyles.green,
              size: 50,
            ),
            Text(
              "Aucun incidents",
              style: TextStyle(
                  color: GlobalStyles.backgroundDarkGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class ListIsLoading extends StatelessWidget {
  const ListIsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return BuildLoadingBox(
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
