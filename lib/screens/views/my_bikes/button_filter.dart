// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Components
import 'package:velyvelo/components/pop_up_filter/pop_up_filters.dart';
import 'package:velyvelo/controllers/carte_provider/carte_bike_provider.dart';
import 'package:velyvelo/controllers/map_provider/map_view_provider.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Controllers
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

Future<void> displayFilters(context, WidgetRef ref) async {
  ref
      .read(carteBikeProvider)
      .fetchFilters(ref.read(mapViewProvider).isMapOrList(MapOrList.list));

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const PopUpFilters();
      }).then((value) {
    //
    ref
        .read(carteBikeProvider)
        .fetch(ref.read(mapViewProvider).isMapOrList(MapOrList.list));
  });
}

class ButtonFilter extends ConsumerWidget {
  const ButtonFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: [
      TopButton(
          actionFunction: () {
            displayFilters(context, ref);
          },
          isLoading: false,
          iconButton: Icons.filter_list_outlined),
      ref.watch(carteBikeProvider).filter.isEmpty()
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
