// Vendor
import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

class BuildDropDownForm extends StatelessWidget {
  const BuildDropDownForm({
    Key? key,
    required this.placeholder,
    required this.dropdownItemList,
    required this.setItem,
    this.index
  }) : super(key: key);

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
      resultIcon: Icon(
        Icons.arrow_drop_down,
        color: GlobalStyles.greyDropDown,
      ),
      placeholderTS: TextStyle(
        color: GlobalStyles.greyTextInput,
        fontSize: 16.0,
        fontWeight: FontWeight.w600
      ),
      resultTS: TextStyle(
        color: GlobalStyles.greyTextInput,
        fontSize: 16.0,
        fontWeight: FontWeight.w600
      ),
      resultBD: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: GlobalStyles.backgroundLightGrey,
          width: 3.0
        )
      ),
      dropdownBD: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: GlobalStyles.backgroundLightGrey,
          width: 1.5
        )
      ),
      selectedItemBD: BoxDecoration(
        color: GlobalStyles.backgroundLightGrey
      ),
      selectedItemTS: TextStyle(
        color: GlobalStyles.greyTextInput,
        fontSize: 20.0,
        fontWeight: FontWeight.w600
      ),
    );
  }
}