// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/carte_provider/carte_bike_provider.dart';
import 'package:velyvelo/controllers/carte_provider/carte_hub_provider.dart';

// Components
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/map_provider/map_view_provider.dart';

// Controllers
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

class ButtonSearchVelo extends ConsumerWidget {
  const ButtonSearchVelo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteBikeProvider bikeMap = ref.watch(carteBikeProvider);
    return Stack(children: [
      TopButton(
          actionFunction: () =>
              {ref.read(carteBikeProvider).toggleSearch(true)},
          isLoading: false,
          iconButton: Icons.search),
      bikeMap.filter.searchText == ""
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

  SearchBarVelo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    textInputController.text = ref.read(carteBikeProvider).filter.searchText;
    textInputController.selection = TextSelection.fromPosition(
        TextPosition(offset: textInputController.text.length));
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
                    {ref.read(carteBikeProvider).toggleSearch(false)},
                icon: const Icon(Icons.arrow_back_ios)),
            SizedBox(
              width: screenWidth * 0.5,
              child: TextField(
                maxLength: 100,
                autocorrect: false,
                decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: "Rechercher un vélo"),
                controller: textInputController,
                onChanged: (value) => {
                  ref.read(carteBikeProvider).filter.searchText = value,
                  ref.read(carteBikeProvider).fetch(
                      ref.read(mapViewProvider).isMapOrList(MapOrList.list))
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: ref.watch(carteBikeProvider).filter.searchText != ""
                      ? 1
                      : 0,
                  child: IconButton(
                      onPressed: () => {
                            textInputController.text = "",
                            ref.read(carteBikeProvider).filter.searchText = "",
                            ref.read(carteBikeProvider).fetch(ref
                                .read(mapViewProvider)
                                .isMapOrList(MapOrList.list))
                          },
                      icon: const Icon(Icons.close)),
                )
              ],
            )
          ]),
        ));
  }
}

class ButtonSearchHub extends ConsumerWidget {
  const ButtonSearchHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteHubProvider hubs = ref.watch(carteHubProvider);

    return Stack(children: [
      TopButton(
          actionFunction: () => {ref.read(carteHubProvider).toggleSearch(true)},
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

  SearchBarHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteHubProvider hubs = ref.watch(carteHubProvider);
    textInputController.text = hubs.searchText;
    textInputController.selection = TextSelection.fromPosition(
        TextPosition(offset: textInputController.text.length));
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
                    {ref.read(carteHubProvider).toggleSearch(false)},
                icon: const Icon(Icons.arrow_back_ios)),
            SizedBox(
              width: screenWidth * 0.5,
              child: TextField(
                maxLength: 100,
                autocorrect: false,
                decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: "Rechercher un hub"),
                controller: textInputController,
                onChanged: (value) => {
                  hubs.searchText = value,
                  hubs.fetch(
                      ref.read(mapViewProvider).isMapOrList(MapOrList.list))
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: hubs.searchText != "" ? 1 : 0,
                  child: IconButton(
                      onPressed: () => {
                            textInputController.text = "",
                            hubs.searchText = "",
                            hubs.fetchHubMap()
                          },
                      icon: const Icon(Icons.close)),
                )
              ],
            )
          ]),
        ));
  }
}

class SearchBarIncident extends StatelessWidget {
  final textInputController = TextEditingController();
  final IncidentController incidentController = Get.put(IncidentController());

  SearchBarIncident({super.key});

  @override
  Widget build(BuildContext context) {
    textInputController.text = incidentController.searchText.value;
    textInputController.selection = TextSelection.fromPosition(
        TextPosition(offset: textInputController.text.length));
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
                maxLength: 100,
                autocorrect: false,
                decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: "Rechercher un incident"),
                controller: textInputController,
                onChanged: (value) => {
                  incidentController.searchText.value = value,
                  incidentController.fetchAllIncidents(
                      incidentController.incidentsToFetch.value),
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: textInputController.text != "" ? 1 : 0,
                  child: IconButton(
                      onPressed: () => {
                            textInputController.text = "",
                            incidentController.searchText.value = "",
                            incidentController.fetchAllIncidents(
                                incidentController.incidentsToFetch.value),
                          },
                      icon: const Icon(Icons.close)),
                )
              ],
            )
          ]),
        ));
  }
}
