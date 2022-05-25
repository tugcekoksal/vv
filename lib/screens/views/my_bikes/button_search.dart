// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Components
import 'package:velyvelo/controllers/hub_controller.dart';
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

class ButtonSearchVelo extends StatelessWidget {
  final MapBikesController mapBikesController;

  const ButtonSearchVelo({Key? key, required this.mapBikesController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(children: [
        TopButton(
            actionFunction: () =>
                {mapBikesController.displaySearch.value = true},
            isLoading: false,
            iconButton: Icons.search),
        mapBikesController.searchText.value == ""
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

class SearchBarVelo extends StatelessWidget {
  final textInputController = TextEditingController();
  final MapBikesController mapBikeController = Get.put(MapBikesController());

  SearchBarVelo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textInputController.text = mapBikeController.searchText.value;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () =>
                    {mapBikeController.displaySearch.value = false},
                icon: const Icon(Icons.arrow_back_ios)),
            SizedBox(
              width: screenWidth * 0.5,
              child: TextField(
                autocorrect: false,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Rechercher un vélo"),
                controller: textInputController,
                onChanged: (value) => {
                  mapBikeController.searchText.value = value,
                  mapBikeController.bikesBySearch(),
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => {
                          textInputController.text = "",
                          mapBikeController.searchText.value = "",
                          mapBikeController.bikesBySearch(),
                        },
                    icon: const Icon(Icons.close)),
              ],
            )
          ]),
        ));
  }
}

class ButtonSearchHub extends StatelessWidget {
  final HubController hubController;

  const ButtonSearchHub({Key? key, required this.hubController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(children: [
        TopButton(
            actionFunction: () => {hubController.displaySearch.value = true},
            isLoading: false,
            iconButton: Icons.search),
        hubController.searchText.value == ""
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

class SearchBarHub extends StatelessWidget {
  final textInputController = TextEditingController();
  final HubController hubController = Get.put(HubController());

  SearchBarHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textInputController.text = hubController.searchText.value;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () => {hubController.displaySearch.value = false},
                icon: const Icon(Icons.arrow_back_ios)),
            SizedBox(
              width: screenWidth * 0.5,
              child: TextField(
                autocorrect: false,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Rechercher un hub"),
                controller: textInputController,
                onChanged: (value) => {
                  hubController.searchText.value = value,
                  hubController.hubsBySearch(),
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => {
                          textInputController.text = "",
                          hubController.searchText.value = "",
                          hubController.hubsBySearch(),
                        },
                    icon: const Icon(Icons.close)),
              ],
            )
          ]),
        ));
  }
}

class ButtonSearchIncident extends StatelessWidget {
  final IncidentController incidentController;

  const ButtonSearchIncident({Key? key, required this.incidentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(children: [
        TopButton(
            actionFunction: () =>
                {incidentController.displaySearch.value = true},
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

class SearchBarIncident extends StatelessWidget {
  final textInputController = TextEditingController();
  final IncidentController incidentController = Get.put(IncidentController());

  SearchBarIncident({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textInputController.text = incidentController.searchText.value;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () =>
                    {incidentController.displaySearch.value = false},
                icon: const Icon(Icons.arrow_back_ios)),
            SizedBox(
              width: screenWidth * 0.5,
              child: TextField(
                autocorrect: false,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Rechercher un hub"),
                controller: textInputController,
                onChanged: (value) => {
                  incidentController.searchText.value = value,
                  incidentController.incidentsBySearch(),
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => {
                          textInputController.text = "",
                          incidentController.searchText.value = "",
                          incidentController.incidentsBySearch(),
                        },
                    icon: const Icon(Icons.close)),
              ],
            )
          ]),
        ));
  }
}
