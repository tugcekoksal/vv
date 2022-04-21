// Vendor
import 'package:flutter/material.dart';
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class StatusVeloDropDown extends StatelessWidget {
  const StatusVeloDropDown({
    Key? key,
    required this.incidentController,
  }) : super(key: key);

  final IncidentController incidentController;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: TextTheme(
        subtitle1: TextStyle(
            color: GlobalStyles.greyTextInput,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: "Montserrat"),
      )),
      child: DropdownSearch<String>(
          mode: Mode.MENU,
          showSelectedItems: true,
          showSearchBox: true,
          dropdownSearchDecoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: GlobalStyles.backgroundLightGrey, width: 3.0)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: GlobalStyles.backgroundLightGrey, width: 3.0)),
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(15.0, 0.0, 2.0, 0.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: GlobalStyles.backgroundLightGrey, width: 3.0)),
            errorStyle: TextStyle(
                color: GlobalStyles.purple,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
            hintText: "Statut du vélo",
            hintStyle: TextStyle(
                color: GlobalStyles.greyTextInput,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          popupElevation: 8,
          popupItemBuilder: (BuildContext context, item, bool isSelected) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: !isSelected
                  ? null
                  : BoxDecoration(
                      // border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                      // color: Colors.white,
                      color: GlobalStyles.backgroundLightGrey),
              child: ListTile(
                // selected: isSelected,
                title: Text(item,
                    style: TextStyle(color: GlobalStyles.greyTextInput)),
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
                        color: GlobalStyles.yellow,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Icon(
                      Icons.search_off_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Aucun résultats",
                    style: TextStyle(
                        color: GlobalStyles.backgroundDarkGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )),
          popupShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(
                  color: GlobalStyles.backgroundLightGrey, width: 1.5)),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: GlobalStyles.backgroundLightGrey, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: GlobalStyles.backgroundLightGrey, width: 2.5)),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              hintText: "Rechercher",
              hintStyle: TextStyle(
                  color: GlobalStyles.greyTextInput,
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
