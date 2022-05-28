// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global Styles like colors
import 'package:velyvelo/config/color_status_typology.dart';

// Provider
import 'package:velyvelo/controllers/bike_provider/bikes_provider.dart';

class BuildButtonStatus extends StatelessWidget {
  const BuildButtonStatus(
      {Key? key,
      required this.label,
      required this.setFilters,
      required this.isSelected})
      : super(key: key);

  final String label;
  final Function setFilters;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
        padding: const EdgeInsets.all(0),
        labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        label: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : colorStatusTypology[label],
                fontSize: 12.0,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        shape: StadiumBorder(
            side: BorderSide(color: colorStatusTypology[label], width: 1.5)),
        onSelected: (bool value) => setFilters(value, label),
        checkmarkColor: colorStatusTypology[label],
        showCheckmark: false,
        selected: isSelected,
        selectedColor: colorStatusTypology[label],
        pressElevation: 0.0);
  }
}

class PopUpStatusList extends ConsumerWidget {
  const PopUpStatusList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BikesProvider bikes = ref.watch(bikesProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
            spacing: 4.0,
            direction: Axis.horizontal,
            children: bikes.availableStatus
                .map((statusLabel) => BuildButtonStatus(
                      label: statusLabel,
                      setFilters: bikes.setStatus,
                      isSelected:
                          bikes.selectedStatusList.contains(statusLabel),
                    ))
                .toList()),
      ],
    );
  }
}
