// Vendor
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

class DropDown extends StatelessWidget {
  const DropDown(
      {Key? key,
      required this.placeholder,
      required this.dropdownItemList,
      required this.setItem,
      this.index})
      : super(key: key);

  final String placeholder;
  final List<String> dropdownItemList;
  final Function setItem;
  final int? index;

  @override
  Widget build(BuildContext context) {
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
          dropdownSearchDecoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: global_styles.backgroundLightGrey, width: 3.0)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: global_styles.backgroundLightGrey, width: 3.0)),
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(15.0, 0.0, 2.0, 0.0),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: global_styles.backgroundLightGrey, width: 3.0)),
            errorStyle: const TextStyle(
                color: global_styles.purple,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
            hintText: placeholder,
            hintStyle: const TextStyle(
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
                      // border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                      // color: Colors.white,
                      color: global_styles.backgroundLightGrey),
              child: ListTile(
                // selected: isSelected,
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
                    "Aucun résultats",
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
          items: dropdownItemList,
          onChanged: (value) {
            if (index != null) {
              setItem(value, index);
            } else {
              setItem(value);
            }
          }),
    );
  }
}
