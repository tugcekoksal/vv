// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

// Globals styles
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/screens/views/my_bikes/usefull.dart';

class PurpleText extends StatelessWidget {
  final String text;

  const PurpleText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: GlobalStyles.purple,
            fontSize: 17.0,
            fontWeight: FontWeight.w600));
  }
}

class MapStatusVelo extends StatelessWidget {
  final String text;
  const MapStatusVelo({Key? key, required this.text}) : super(key: key);

  Color colorBasedOnVeloMapStatus(String status) {
    switch (status) {
      case "Rangé":
        return GlobalStyles.green;
      case "Utilisé":
        return GlobalStyles.blue;
      case "Volé":
        return GlobalStyles.orange;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 100),
      child: Container(
          width: 100,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: colorBasedOnVeloMapStatus(text),
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Center(
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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

  const VeloCard(
      {Key? key,
      required this.name,
      required this.group,
      required this.mapStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(
            bottom: 4.0, top: 4.0, left: 16.0, right: 16.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PurpleText(text: name),
                MapStatusVelo(text: mapStatus),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [PurpleText(text: group)],
            )
          ],
        ));
  }
}

class BikesList extends StatelessWidget {
  final MapBikesController mapBikeController;

  const BikesList({Key? key, required this.mapBikeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
          padding: EdgeInsets.only(top: 55),
          child: ListView.builder(
            itemCount: mapBikeController.bikeWithPositionList.length,
            itemBuilder: (context, index) {
              return (GestureDetector(
                child: VeloCard(
                    name: mapBikeController.bikeWithPositionList[index].name,
                    group: mapBikeController.bikeWithPositionList[index].group,
                    mapStatus: mapBikeController
                        .bikeWithPositionList[index].mapStatus),
                onTap: () => {
                  goToBikeProfileFromPk(
                      mapBikeController.bikeWithPositionList[index].veloPk,
                      mapBikeController)
                },
              ));
            },
          ));
    });
  }
}
