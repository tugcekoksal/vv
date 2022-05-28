// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/bike_provider/bikes_provider.dart';

// Components
import 'package:velyvelo/controllers/hub_provider/hubs_provider.dart';
import 'package:velyvelo/controllers/incident_controller.dart';

// Controllers
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

class ButtonSearchVelo extends ConsumerWidget {
  const ButtonSearchVelo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BikesProvider bikes = ref.watch(bikesProvider);
    return Stack(children: [
      TopButton(
          actionFunction: () => {ref.read(bikesProvider).toggleSearch(true)},
          isLoading: false,
          iconButton: Icons.search),
      bikes.searchText == ""
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
  }
}

class SearchBarVelo extends ConsumerWidget {
  final textInputController = TextEditingController();

  SearchBarVelo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textInputController.text = ref.read(bikesProvider).searchText;
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
                onPressed: () => {ref.read(bikesProvider).toggleSearch(false)},
                icon: const Icon(Icons.arrow_back_ios)),
            SizedBox(
              width: screenWidth * 0.5,
              child: TextField(
                autocorrect: false,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Rechercher un vélo"),
                controller: textInputController,
                onChanged: (value) => {
                  ref.read(bikesProvider).searchText = value,
                  ref.read(bikesProvider).bikesBySearch(),
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => {
                          textInputController.text = "",
                          ref.read(bikesProvider).searchText = "",
                          ref.read(bikesProvider).bikesBySearch(),
                        },
                    icon: const Icon(Icons.close)),
              ],
            )
          ]),
        ));
  }
}

class ButtonSearchHub extends ConsumerWidget {
  const ButtonSearchHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HubsProvider hubs = ref.watch(hubsProvider);

    return Stack(children: [
      TopButton(
          actionFunction: () => {ref.read(hubsProvider).toggleSearch(true)},
          isLoading: false,
          iconButton: Icons.search),
      hubs.searchText == ""
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
  }
}

class SearchBarHub extends ConsumerWidget {
  final textInputController = TextEditingController();

  SearchBarHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HubsProvider hubs = ref.watch(hubsProvider);
    textInputController.text = hubs.searchText;
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
                onPressed: () => {ref.read(hubsProvider).toggleSearch(false)},
                icon: const Icon(Icons.arrow_back_ios)),
            SizedBox(
              width: screenWidth * 0.5,
              child: TextField(
                autocorrect: false,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Rechercher un hub"),
                controller: textInputController,
                onChanged: (value) => {
                  hubs.searchText = value,
                  hubs.hubsBySearch(),
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => {
                          textInputController.text = "",
                          hubs.searchText = "",
                          hubs.hubsBySearch(),
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
