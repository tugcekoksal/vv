// Vendor
import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

class BuildDropDownForm extends StatelessWidget {
  const BuildDropDownForm(
      {Key? key,
      required this.placeholder,
      required this.dropdownItemList,
      required this.setItem,
      this.index})
      : super(key: key);

  final String placeholder;
  final dropdownItemList;
  final Function setItem;
  final int? index;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return CoolDropdown(
      dropdownList: dropdownItemList,
      placeholder: placeholder,
      resultWidth: screenWidth - 80,
      onChange: (e) {
        setItem(e, index);
      },
      resultIcon: const Icon(
        Icons.arrow_drop_down,
        color: global_styles.greyDropDown,
      ),
      placeholderTS: const TextStyle(
          color: global_styles.greyTextInput,
          fontSize: 16.0,
          fontWeight: FontWeight.w600),
      resultTS: const TextStyle(
          color: global_styles.greyTextInput,
          fontSize: 16.0,
          fontWeight: FontWeight.w600),
      resultBD: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border:
              Border.all(color: global_styles.backgroundLightGrey, width: 3.0)),
      dropdownBD: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border:
              Border.all(color: global_styles.backgroundLightGrey, width: 1.5)),
      selectedItemBD:
          const BoxDecoration(color: global_styles.backgroundLightGrey),
      selectedItemTS: const TextStyle(
          color: global_styles.greyTextInput,
          fontSize: 20.0,
          fontWeight: FontWeight.w600),
    );
  }
}
