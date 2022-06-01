// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velyvelo/components/fade_list_view.dart';
import 'package:velyvelo/controllers/bike_provider/bikes_provider.dart';

// Globals styles
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/screens/views/incidents_view/incidents_list_info.dart';
import 'package:velyvelo/screens/views/my_bikes/usefull.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color color;

  const TitleText({Key? key, required this.text, required this.color})
      : super(key: key);

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
  const MapStatusVelo({Key? key, required this.text}) : super(key: key);

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
      constraints: const BoxConstraints(maxWidth: 100),
      child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: colorBasedOnVeloMapStatus(text),
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Center(
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
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
    Key? key,
    required this.name,
    required this.group,
    required this.mapStatus,
  }) : super(key: key);

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
                    text: group == "" ? "Pas de groupe" : group,
                    color: global_styles.greyBottomBarText)
              ],
            )
          ],
        ));
  }
}

class BikesList extends ConsumerWidget {
  final RefreshController refreshController = RefreshController();

  BikesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BikesProvider bikes = ref.watch(bikesProvider);
    return Container(
        color: global_styles.backgroundLightGrey,
        child: Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 60),
            child: FadeListView(
                // Need to enable refresh here !
                child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: refreshController,
                    // controller: incidentController.refreshController,
                    onRefresh: () {
                      // Refresh incidents
                      ref.read(bikesProvider).fetchAllBikes();
                      refreshController.refreshCompleted();
                    },
                    onLoading: () {
                      // Add new incidents in the list with newest_id and count
                      // incidentController.fetchNewIncidents();
                      refreshController.loadComplete();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                      itemCount: bikes.bikeWithPositionList.length,
                      itemBuilder: (context, index) {
                        return (GestureDetector(
                          child: VeloCard(
                              name: bikes.bikeWithPositionList[index].name,
                              group: bikes.bikeWithPositionList[index].group,
                              mapStatus:
                                  bikes.bikeWithPositionList[index].mapStatus),
                          onTap: () => {
                            goToBikeProfileFromPk(
                              ref
                                  .read(bikesProvider)
                                  .bikeWithPositionList[index]
                                  .veloPk,
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
      {Key? key, required this.icon, required this.color, required this.text})
      : super(key: key);

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
      {Key? key,
      required this.icon,
      required this.color,
      required this.text,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        InfoEmpty(icon: icon, color: color, text: text),
        const SizedBox(height: 25),
        GestureDetector(
            onTap: () => {action()},
            child: Column(
              children: const [Icon(Icons.refresh), Text("Recharger")],
            ))
      ]),
    );
  }
}

class BikesListView extends ConsumerWidget {
  const BikesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BikesProvider bikes = ref.watch(bikesProvider);
    return Container(
        height: MediaQuery.of(context).size.height,
        color: global_styles.backgroundLightGrey,
        child:
            // If bikes are loading
            bikes.isLoadingBikes
                ? const Padding(
                    padding: EdgeInsets.only(top: 100), child: ListIsLoading())
                :
                // If error loading bikes
                bikes.messageError != ""
                    ? InfoError(
                        action: bikes.fetchAllBikes,
                        icon: Icons.pedal_bike,
                        color: global_styles.orange,
                        text: "Une erreur s'est produite")
                    :
                    // If bikes loaded are empty
                    bikes.bikeWithPositionList.isEmpty
                        ? const InfoEmpty(
                            icon: Icons.pedal_bike,
                            color: global_styles.greyUnselectedIcon,
                            text: "Aucun vélo trouvé")
                        :
                        // Else bikes loaded good
                        BikesList());
  }
}
