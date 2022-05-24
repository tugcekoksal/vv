// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

// Controllers
import 'package:velyvelo/controllers/map_controller.dart';

class SwitchButton extends StatelessWidget {
  final String textButton;
  final bool isActive;

  const SwitchButton(
      {Key? key, required this.textButton, required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Container(
      decoration: BoxDecoration(
          color:
              isActive ? global_styles.blue : global_styles.backgroundDarkGrey,
          borderRadius: BorderRadius.circular(30)),
      width: 60,
      height: 30,
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
              color:
                  isActive ? Colors.white : global_styles.backgroundLightGrey,
              fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}

class TopSwitch extends StatelessWidget {
  final bool mapActive = true;
  final bool listActive = false;

  final MapBikesController mapBikesController;
  final Function changeMapView;

  const TopSwitch(
      {Key? key, required this.mapBikesController, required this.changeMapView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Container(
        decoration: BoxDecoration(
          color: global_styles.backgroundDarkGrey,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 3,
            ),
          ],
        ),
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

class TopButton extends StatefulWidget {
  final bool isLoading;
  final IconData iconButton;
  final Function actionFunction;

  const TopButton(
      {Key? key,
      required this.isLoading,
      required this.actionFunction,
      required this.iconButton})
      : super(key: key);

  @override
  State<TopButton> createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> {
  @override
  Widget build(BuildContext context) {
    return (GestureDetector(
        onTap: () {
          if (!widget.isLoading) widget.actionFunction();
        },
        child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 3,
                ),
              ],
              color: Colors.white,
            ),
            child: widget.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: global_styles.greyTitle,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      widget.iconButton,
                      color: global_styles.backgroundDarkGrey,
                      size: 25.0,
                    ),
                  ))));
  }
}

class TopOptions extends StatelessWidget {
  final MapBikesController mapBikesController;
  final Function changeMapView;
  final Function changeMapStyle;

  const TopOptions(
      {Key? key,
      required this.mapBikesController,
      required this.changeMapView,
      required this.changeMapStyle})
      : super(key: key);

  // Method to instantiate the filter's page
  Future<void> showFilters() async {
    // mapBikesController.isFiltersChanged(false);
    // return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return BuildPopUpFilters();
    //     }).then((value) {
    //   // Check if filters have changed and fire the fetch of bikes if true
    //   mapBikesController.onChangeFilters();
    //   // If fetchAllBikes() gets no bikes then show it to the user
    // });
  }

  // Method to instantiate the filter's page
  Future<void> showSearch() async {
    // return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return BuildPopUpSearch();
    //     }).then((value) {
    //   // Check if filters have changed and fire the fetch of bikes if true
    //   mapBikesController.bikesBySearch();
    //   // If fetchAllBikes() gets no bikes then show it to the user
    // });
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                        isLoading: false,
                        iconButton: Icons.qr_code_scanner,
                        actionFunction: () {},
                      ),
                      const SizedBox(width: 10.0),
                      Obx(() {
                        return TopButton(
                          isLoading: mapBikesController.isLoadingFilters.value,
                          iconButton: Icons.filter_list_outlined,
                          actionFunction: showFilters,
                        );
                      }),
                      const SizedBox(width: 10.0),
                      TopButton(
                        isLoading: false,
                        iconButton: Icons.search,
                        actionFunction: showSearch,
                      ),
                    ],
                  ),
                ],
              ),
            ])));
  }
}
