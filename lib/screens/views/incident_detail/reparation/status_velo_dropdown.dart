// Vendor
import 'package:flutter/material.dart';
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

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

    return Theme(
      data: ThemeData(
          textTheme: const TextTheme(
        subtitle1: TextStyle(
            color: global_styles.greyTextInput,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: "Montserrat"),
      )),
      child: DropdownSearch<String>(
          mode: Mode.MENU,
          showSelectedItems: true,
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: global_styles.backgroundLightGrey, width: 3.0)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: global_styles.backgroundLightGrey, width: 3.0)),
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 2.0, 0.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: global_styles.backgroundLightGrey, width: 3.0)),
            errorStyle: TextStyle(
                color: global_styles.purple,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
            hintText: "Statut du vélo",
            hintStyle: TextStyle(
                color: global_styles.greyTextInput,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          popupElevation: 8,
          popupItemBuilder: (BuildContext context, item, bool isSelected) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: !isSelected
                  ? null
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: global_styles.backgroundLightGrey),
              child: ListTile(
                title: Text(item,
                    style: const TextStyle(color: global_styles.greyTextInput)),
              ),
            );
          },
          emptyBuilder: (context, searchEntry) => Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: global_styles.yellow,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: const Icon(
                      Icons.search_off_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Aucun résultat",
                    style: TextStyle(
                        color: global_styles.backgroundDarkGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )),
          popupShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(
                  color: global_styles.backgroundLightGrey, width: 1.5)),
          searchFieldProps: TextFieldProps(
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: global_styles.backgroundLightGrey, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: global_styles.backgroundLightGrey, width: 2.5)),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              hintText: "Rechercher",
              hintStyle: TextStyle(
                  color: global_styles.greyTextInput,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          selectedItem: incidentController.currentReparation.value.statusBike,
          items: incidentController.incidentDetailValue.value.status,
          onChanged: (value) {
            incidentController.setBikeStatus(value);
          }),
    );
  }
}
