// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Components
import 'package:velyvelo/components/BuildPopUpFilters.dart';
import 'package:velyvelo/components/BuildPopUpSearch.dart';
import 'package:velyvelo/components/BuildQRCodeScanner.dart';

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';
import 'package:velyvelo/controllers/navigation_controller.dart';
import 'package:velyvelo/screens/views/scanView.dart';

class SwitchButton extends StatelessWidget {
  final String textButton;
  final bool isActive;

  SwitchButton({Key? key, required this.textButton, required this.isActive});

  Widget build(BuildContext context) {
    return (Container(
      decoration: BoxDecoration(
          color: isActive ? GlobalStyles.blue : Colors.white,
          borderRadius: BorderRadius.circular(30)),
      width: 60,
      height: 30,
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
              color: isActive ? Colors.white : GlobalStyles.backgroundDarkGrey,
              fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}

class TopSwitch extends StatelessWidget {
  bool mapActive = true;
  bool listActive = false;

  final MapBikesController mapBikesController;
  final Function changeMapView;

  TopSwitch(
      {Key? key,
      required this.mapBikesController,
      required this.changeMapView});
  Widget build(BuildContext context) {
    return (Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        width: 130,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  if (!mapBikesController.isMapView) changeMapView();
                },
                child: SwitchButton(
                    textButton: "Map", isActive: mapBikesController.isMapView)),
            GestureDetector(
                onTap: () {
                  if (mapBikesController.isMapView) changeMapView();
                },
                child: SwitchButton(
                    textButton: "Liste",
                    isActive: !mapBikesController.isMapView)),
          ],
        )));
  }
}

class TopButton extends StatelessWidget {
  final MapBikesController mapBikesController;
  final IconData iconButton;

  Function actionFunction;

  TopButton(
      {Key? key,
      required this.mapBikesController,
      required this.actionFunction,
      required this.iconButton})
      : super(key: key);

  Widget build(BuildContext context) {
    return (Obx(() {
      return GestureDetector(
          onTap: () {
            if (!mapBikesController.isLoadingFilters.value)
              actionFunction(context);
          },
          child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0)),
              child: mapBikesController.isLoadingFilters.value
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: GlobalStyles.greyTitle,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Icon(
                      iconButton,
                      color: GlobalStyles.greyTitle,
                      size: 30.0,
                    )));
    }));
  }
}

class TopOptions extends StatelessWidget {
  final MapBikesController mapBikesController;
  final Function changeMapView;
  final Function refresh;

  TopOptions(
      {Key? key,
      required this.mapBikesController,
      required this.changeMapView,
      required this.refresh})
      : super(key: key);

  // Method to instantiate the filter's page
  Future<void> showFilters(context) async {
    mapBikesController.isFiltersChanged(false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BuildPopUpFilters();
        }).then((value) {
      // Check if filters have changed and fire the fetch of bikes if true
      mapBikesController.onChangeFilters();
      // If fetchAllBikes() gets no bikes then show it to the user
    });
  }

  // Method to instantiate the filter's page
  Future<void> showSearch(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BuildPopUpSearch();
        }).then((value) {
      // Check if filters have changed and fire the fetch of bikes if true
      mapBikesController.bikesBySearch();
      // If fetchAllBikes() gets no bikes then show it to the user
    });
  }

  Future<void> showScan(context) async {
    Get.to(Scaffold(body: ScanView()));
  }

  Future<void> fetchBikes(context) async {
    mapBikesController.fetchAllBikes();
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
        margin: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              TopSwitch(
                  mapBikesController: mapBikesController,
                  changeMapView: changeMapView)
            ]),
            Row(
              children: [
                TopButton(
                    mapBikesController: mapBikesController,
                    iconButton: Icons.qr_code_scanner,
                    actionFunction: showScan),
                const SizedBox(width: 10.0),
                TopButton(
                    mapBikesController: mapBikesController,
                    iconButton: Icons.filter_list_outlined,
                    actionFunction: showFilters),
                const SizedBox(width: 10.0),
                TopButton(
                    mapBikesController: mapBikesController,
                    iconButton: Icons.search,
                    actionFunction: showSearch),
                const SizedBox(width: 10.0),
                TopButton(
                    mapBikesController: mapBikesController,
                    iconButton: Icons.update,
                    actionFunction: fetchBikes),
              ],
            ),
          ],
        )));
  }
}
