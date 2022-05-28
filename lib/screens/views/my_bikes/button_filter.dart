// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Components
import 'package:velyvelo/components/pop_up_filter/pop_up_filters.dart';
import 'package:velyvelo/controllers/bike_provider/bikes_provider.dart';

// Controllers
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

class ButtonFilter extends ConsumerWidget {
  const ButtonFilter({Key? key}) : super(key: key);

  Future<void> displayFilters(context, BikesProvider bikes) async {
    bikes.isFiltersChanged = false;
    bikes.fetchFilters();

    return showDialog(
        // barrierDismissible: false,
        // useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return const PopUpFilters();
        }).then((value) {
      // Check if filters have changed and fire the fetch of bikes if true
      bikes.onChangeFilters();
      // If fetchAllBikes() gets no bikes then show it to the user
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TopButton(
        actionFunction: () => displayFilters(context, ref.read(bikesProvider)),
        isLoading: false,
        iconButton: Icons.filter_list_outlined);
  }
}
