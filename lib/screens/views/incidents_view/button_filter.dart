// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velyvelo/components/pop_up_filter/pop_up_list_filters.dart';

// Components
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/components/pop_up_filter/pop_up_list_group.dart';
import 'package:velyvelo/components/pop_up_filter/pop_up_titles.dart';
import 'package:velyvelo/controllers/login_controller.dart';

// Controllers
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

class PopUpActiveFilters extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final IncidentController incidentController = Get.put(IncidentController());

  PopUpActiveFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.15),
        child: Row(children: [
          Expanded(
              child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: Obx(() {
              return ListView(
                controller: scrollController,
                shrinkWrap: true,
                children: [
                  Wrap(
                      spacing: 4.0,
                      direction: Axis.horizontal,
                      children: incidentController
                              .incidentsToFetch.value.clientList.isEmpty
                          ? []
                          : incidentController.incidentsToFetch.value.clientList
                              .map((client) => BuildButtonSelectedFilter(
                                  text: client.name ?? "Erreur",
                                  setFilters:
                                      incidentController.setClientFilter))
                              .toList()),
                  Wrap(
                      spacing: 4.0,
                      direction: Axis.horizontal,
                      children: incidentController
                              .incidentsToFetch.value.groupList.isEmpty
                          ? []
                          : incidentController.incidentsToFetch.value.groupList
                              .map((group) => BuildButtonSelectedFilter(
                                  text: group.name ?? "Erreur",
                                  setFilters:
                                      incidentController.setGroupFilter))
                              .toList())
                ],
              );
            }),
          ))
        ]));
  }
}

// ICI refacto avec widget d en dessous
class PopUpClientList extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final IncidentController incidentController = Get.put(IncidentController());

  PopUpClientList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ListView(
        controller: scrollController,
        children: [
          Obx(() {
            return Wrap(
                spacing: 4.0,
                direction: Axis.horizontal,
                children: incidentController.clientListFilter.isEmpty
                    ? const [Text("Aucun filtre disponible")]
                    : incidentController.clientListFilter.map((client) {
                        return BuildButtonGroup(
                            label: client.name ?? "Erreur",
                            setFilters: incidentController.setClientFilter,
                            isSelected: incidentController
                                .incidentsToFetch.value.clientList
                                .map((item) => item.id)
                                .contains(client.id));
                      }).toList());
          })
        ],
      ),
    ));
  }
}

class PopUpGroupList extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final IncidentController incidentController = Get.put(IncidentController());

  PopUpGroupList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ListView(
        controller: scrollController,
        children: [
          Obx(() {
            return Wrap(
                spacing: 4.0,
                direction: Axis.horizontal,
                children: incidentController.groupListFilter.isEmpty
                    ? const [Text("Aucun filtre disponible")]
                    : incidentController.groupListFilter.map((group) {
                        return BuildButtonGroup(
                            label: group.name ?? "Erreur",
                            setFilters: incidentController.setGroupFilter,
                            isSelected: incidentController
                                .incidentsToFetch.value.groupList
                                .map((item) => item.id)
                                .contains(group.id));
                      }).toList());
          })
        ],
      ),
    ));
  }
}

class PopUpFilters extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  PopUpFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SimpleDialog(
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        alignment: Alignment.topCenter,
        children: [
          Container(
            constraints: BoxConstraints(
                maxHeight: loginController.isAdminOrTech.value
                    ? screenHeight * 0.7
                    : screenHeight * 0.4),
            width: screenWidth,
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.0)),
                color: Colors.white),
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const PopUpTitle(text: "Filtrer mes Incidents"),
              const PopUpSubTitle(text: "Filtres appliqués"),
              PopUpActiveFilters(),
              loginController.isAdminOrTech.value
                  ? const PopUpSubTitle(text: "Clients")
                  : const SizedBox(),
              loginController.isAdminOrTech.value
                  ? PopUpClientList()
                  : const SizedBox(),
              const PopUpSubTitle(text: "Groupes"),
              PopUpGroupList()
            ]),
          )
        ]);
  }
}

Future<void> displayFilters(
    context, IncidentController incidentController) async {
  incidentController.fetchIncidentFilters();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUpFilters();
      }).then((value) {
    incidentController
        .fetchAllIncidents(incidentController.incidentsToFetch.value);
  });
}

class ButtonFilter extends StatelessWidget {
  ButtonFilter({Key? key}) : super(key: key);
  final IncidentController incidentController = Get.put(IncidentController());

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      TopButton(
          actionFunction: () {
            displayFilters(context, incidentController);
          },
          isLoading: false,
          iconButton: Icons.filter_list_outlined),
      Obx(() {
        return incidentController.incidentsToFetch.value.clientList.isEmpty &&
                incidentController.incidentsToFetch.value.groupList.isEmpty
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
                    )));
      })
    ]);
  }
}
