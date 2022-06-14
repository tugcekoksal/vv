// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Provider
import 'package:velyvelo/controllers/carte_provider/carte_bike_provider.dart';
import 'package:velyvelo/controllers/map_provider/map_view_provider.dart';

class BuildButtonGroup extends StatelessWidget {
  const BuildButtonGroup(
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
                color: isSelected
                    ? Colors.white
                    : global_styles.backgroundDarkGrey,
                fontSize: 12.0,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        shape: const StadiumBorder(
            side: BorderSide(
                color: global_styles.backgroundDarkGrey, width: 1.5)),
        onSelected: (bool value) => setFilters(value, label),
        checkmarkColor: global_styles.blue,
        showCheckmark: false,
        selected: isSelected,
        selectedColor: global_styles.backgroundDarkGrey,
        pressElevation: 0.0);
  }
}

class PopUpGroupBikeList extends ConsumerWidget {
  const PopUpGroupBikeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteBikeProvider bikes = ref.watch(carteBikeProvider);
    return Wrap(
        spacing: 4.0,
        direction: Axis.horizontal,
        children: bikes.filter.availableGroupsList.isEmpty
            ? const [Text("Aucun filtre disponible")]
            : bikes.filter.availableGroupsList
                .map((filterLabel) => BuildButtonGroup(
                    label: filterLabel,
                    setFilters: bikes.setFilters,
                    isSelected:
                        bikes.filter.selectedGroupsList.contains(filterLabel)))
                .toList());
  }
}

class PopUpGroupBikeMap extends ConsumerWidget {
  const PopUpGroupBikeMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteBikeProvider bikes = ref.watch(carteBikeProvider);
    return Wrap(
        spacing: 4.0,
        direction: Axis.horizontal,
        children: bikes.filter.availableGroupsList.isEmpty
            ? const [Text("Aucun filtre disponible")]
            : bikes.filter.availableGroupsList
                .map((filterLabel) => BuildButtonGroup(
                    label: filterLabel,
                    setFilters: bikes.setFilters,
                    isSelected:
                        bikes.filter.selectedGroupsList.contains(filterLabel)))
                .toList());
  }
}

class PopUpGroupList extends ConsumerWidget {
  final ScrollController scrollController = ScrollController();

  PopUpGroupList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ListView(
        controller: scrollController,
        children: [
          ref.read(mapViewProvider).isMapOrList(MapOrList.list)
              ? const PopUpGroupBikeList()
              : const PopUpGroupBikeMap()
        ],
      ),
    ));
  }
}
