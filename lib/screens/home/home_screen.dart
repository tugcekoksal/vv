// Vendor
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;
import 'package:velyvelo/screens/home/button_account.dart';
import 'package:velyvelo/screens/home/title_app_bar.dart';

// Views
import 'package:velyvelo/screens/views/incidents_view/incidents_view.dart';
import 'package:velyvelo/screens/views/login_view.dart';
import 'package:velyvelo/screens/views/my_bikes/my_bikes_view.dart';
import 'package:velyvelo/screens/views/incidents_declaration.dart';

//Controllers
import 'package:velyvelo/controllers/navigation_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final NavigationController navigationController =
      Get.put(NavigationController());
  final LoginController loginController = Get.put(LoginController());

  final PageController _pageController = PageController(initialPage: 0);

  // 123e wekf here to change the last isnt usefull
  final List<String> tabTitleClient = ["Mes incidents", "Carte", "Scanner"];

  showDeclarationIncidentPage() {
    Get.to(() => IncidentDeclaration(),
        transition: Transition.downToUp, duration: Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.transparent,
        child: Scaffold(
            backgroundColor: loginController.isLogin.value
                ? Colors.white
                : GlobalStyles.loginBackground,
            resizeToAvoidBottomInset: false,
            body: Obx(() {
              if (loginController.isLogin.value) {
                return PageView(
                  onPageChanged: (index) =>
                      navigationController.changePage(index),
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
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
              return Container(
                  height: 60.0,
                  width: 60.0,
                  child: navigationController.currentIndex.value == 0 &&
                          loginController.isLogin.value
                      ? FloatingActionButton(
                          backgroundColor: GlobalStyles.backgroundDarkGrey,
                          onPressed: () => showDeclarationIncidentPage(),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ))
                      : SizedBox());
            }),
            bottomNavigationBar: Obx(() {
              if (loginController.isLogin.value) {
                return BottomNavigationBar(
                    iconSize: 35.0,
                    backgroundColor: GlobalStyles.backgroundDarkGrey,
                    selectedItemColor: Colors.white,
                    selectedIconTheme:
                        IconThemeData(color: GlobalStyles.blue, size: 25.0),
                    selectedLabelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedItemColor: GlobalStyles.greyBottomBarText,
                    unselectedIconTheme: IconThemeData(
                        color: GlobalStyles.greyUnselectedIcon, size: 25.0),
                    unselectedLabelStyle: TextStyle(
                        color: GlobalStyles.greyBottomBarText,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600),
                    currentIndex: navigationController.currentIndex.value,
                    onTap: (index) {
                      navigationController.changePage(index);
                      _pageController
                          .jumpToPage(navigationController.currentIndex.value);
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Icon(CupertinoIcons.wrench)),
                          label: "Incidents"),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: Icon(Icons.map_outlined),
                          ),
                          label: "Carte"),
                    ]);
              } else {
                return SizedBox();
              }
            })));
  }
}
