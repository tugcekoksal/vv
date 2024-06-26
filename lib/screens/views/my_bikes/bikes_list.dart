// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/components/list_is_loading.dart';

// Globals styles
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/carte_provider/carte_bike_provider.dart';
import 'package:velyvelo/screens/views/my_bikes/usefull.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color color;

  const TitleText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 17.0, fontWeight: FontWeight.w600)));
  }
}

class MapStatusVelo extends StatelessWidget {
  final String text;
  const MapStatusVelo({super.key, required this.text});

  Color colorBasedOnVeloMapStatus(String status) {
    switch (status) {
      case "Rangé":
        return global_styles.green;
      case "Utilisé":
        return global_styles.blue;
      case "Volé":
        return global_styles.orange;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 90),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: colorBasedOnVeloMapStatus(text),
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Center(
              child: Text(text,
                  // overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800)))),
    );
  }
}

class VeloCard extends StatelessWidget {
  final String name;
  final String group;
  final String mapStatus;

  const VeloCard({
    super.key,
    required this.name,
    required this.group,
    required this.mapStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
            bottom: 4.0, top: 4.0, left: 20.0, right: 20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText(
                  text: name,
                  color: global_styles.purple,
                ),
                MapStatusVelo(text: mapStatus),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                TitleText(
                    text: group == "" ? "Sans groupe" : group,
                    color: global_styles.greyBottomBarText)
              ],
            )
          ],
        ));
  }
}

class BikesList extends ConsumerWidget {
  final RefreshController refreshController = RefreshController();

  BikesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteBikeProvider bikeList = ref.watch(carteBikeProvider);
    return Container(
        color: global_styles.backgroundLightGrey,
        child: Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 60),
            child: FadeListView(
                child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    controller: refreshController,
                    onRefresh: () {
                      ref.read(carteBikeProvider).fetchBikeList();
                      refreshController.refreshCompleted();
                    },
                    onLoading: () {
                      // Add new bikes in the list with newest_id and count
                      ref
                          .read(carteBikeProvider)
                          .fetchNewBikeList()
                          .then((isNotEmpty) {
                        if (isNotEmpty) {
                          refreshController.loadComplete();
                        } else {
                          refreshController.loadNoData();
                        }
                      });
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                      itemCount: bikeList.bikeList.length,
                      itemBuilder: (context, index) {
                        return (GestureDetector(
                          // To change with call api
                          child: VeloCard(
                              name: bikeList.bikeList[index].name ??
                                  "Pas de nom de vélo",
                              group: bikeList.bikeList[index].groupName ??
                                  "Pas de nom de groupe",
                              mapStatus: bikeList.bikeList[index].mapStatus ??
                                  "Pas de gps"),
                          onTap: () => {
                            goToBikeProfileFromPk(
                              ref.read(carteBikeProvider).bikeList[index].id ??
                                  0,
                            )
                          },
                        ));
                      },
                    )))));
  }
}

class InfoEmpty extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const InfoEmpty(
      {super.key, required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 100,
          color: color,
        ),
        Text(
          text,
          style: const TextStyle(color: global_styles.greyUnselectedIcon),
        )
      ],
    ));
  }
}

class InfoError extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final Function action;

  const InfoError(
      {super.key,
      required this.icon,
      required this.color,
      required this.text,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        InfoEmpty(icon: icon, color: color, text: text),
        const SizedBox(height: 25),
        GestureDetector(
            onTap: () => {action()},
            child: const Column(
              children: [Icon(Icons.refresh), Text("Recharger")],
            ))
      ]),
    );
  }
}

class BikesListView extends ConsumerWidget {
  const BikesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CarteBikeProvider bikeList = ref.watch(carteBikeProvider);
    return Container(
        height: MediaQuery.of(context).size.height,
        color: global_styles.backgroundLightGrey,
        child:
            // If bikes are loading
            bikeList.isLoadingBikes
                ? const Padding(
                    padding: EdgeInsets.only(top: 100), child: ListIsLoading())
                :
                // If error loading bikes
                bikeList.messageError != ""
                    ? InfoError(
                        action: bikeList.fetchBikeList,
                        icon: Icons.pedal_bike,
                        color: global_styles.orange,
                        text: "Une erreur s'est produite")
                    :
                    // If bikes loaded are empty
                    bikeList.bikeList.isEmpty
                        ? const InfoEmpty(
                            icon: Icons.pedal_bike,
                            color: global_styles.greyUnselectedIcon,
                            text: "Aucun vélo trouvé")
                        :
                        // Else bikes loaded good
                        BikesList());
  }
}
