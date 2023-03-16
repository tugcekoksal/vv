// Vendor
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/screens/views/incidents/incidents_view.dart';

// Views
import 'package:velyvelo/screens/views/login_view.dart';
import 'package:velyvelo/screens/views/my_bikes/my_bikes_view.dart';
import 'package:velyvelo/screens/views/incident_declaration/incident_declaration_view.dart';

//Controllers
import 'package:velyvelo/controllers/navigation_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final NavigationController navigationController =
      Get.put(NavigationController());
  final LoginController loginController = Get.put(LoginController());
  final PageController _pageController = Get.put(PageController());
  final log = logger(HomeScreen);

  showDeclarationIncidentPage() {
    Get.to(() => const IncidentDeclaration(),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    // navigationController.currentIndex.value = 0;
    return Container(
        color: Colors.transparent,
        child: Scaffold(
            backgroundColor: global_styles.loginBackground,
            resizeToAvoidBottomInset: false,
            body: Obx(() {
              if (loginController.isLogged.value) {
                return PageView(
                  onPageChanged: (index) =>
                      navigationController.changePage(index),
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    IncidentsView(),
                    MyBikesView(),
                  ],
                );
              } else {
                return LoginView();
              }
            }),
            floatingActionButton: Obx(() {
              return SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: navigationController.currentIndex.value == 0 &&
                          loginController.isLogged.value
                      ? FloatingActionButton(
                          backgroundColor: global_styles.backgroundDarkGrey,
                          onPressed: () => showDeclarationIncidentPage(),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ))
                      : const SizedBox());
            }),
            bottomNavigationBar: Obx(() {
              if (loginController.isLogged.value) {
                return Obx(() {
                  return BottomNavigationBar(
                      iconSize: 35.0,
                      backgroundColor: global_styles.backgroundDarkGrey,
                      selectedItemColor: Colors.white,
                      selectedIconTheme: const IconThemeData(
                          color: global_styles.blue, size: 25.0),
                      selectedLabelStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedItemColor: global_styles.greyBottomBarText,
                      unselectedIconTheme: const IconThemeData(
                          color: global_styles.greyUnselectedIcon, size: 25.0),
                      unselectedLabelStyle: const TextStyle(
                          color: global_styles.greyBottomBarText,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600),
                      currentIndex: navigationController.currentIndex.value,
                      onTap: (index) {
                        navigationController.changePage(index);
                        _pageController.jumpToPage(
                            navigationController.currentIndex.value);
                      },
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Padding(
                                key: Key("bottom-navbar-incident"),
                                padding: EdgeInsets.symmetric(vertical: 3.0),
                                child: Icon(CupertinoIcons.wrench)),
                            label: "Incidents"),
                        BottomNavigationBarItem(
                            icon: Padding(
                              key: Key("bottom-navbar-map"),
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Icon(Icons.map_outlined),
                            ),
                            label: "Carte"),
                      ]);
                });
              } else {
                return const SizedBox();
              }
            })));
  }
}
