// Vendor
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Views
import 'package:velyvelo/screens/views/incidents_view.dart';
import 'package:velyvelo/screens/views/login_view.dart';
import 'package:velyvelo/screens/views/my_bikes/my_bikes_view.dart';
import 'package:velyvelo/screens/views/my_bike_view.dart';
import 'package:velyvelo/screens/views/ScanView.dart';
import 'package:velyvelo/screens/views/incidents_declaration.dart';

//Controllers
import 'package:velyvelo/controllers/navigation_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final NavigationController navigationController =
      Get.put(NavigationController());
  final LoginController loginController = Get.put(LoginController());

  PageController _pageController = PageController(initialPage: 0);

  // unused ??
  final List<String> tabTitleUser = ["Mes incidents", "Mes vélos", "Mon vélo"];
  final List<String> tabTitleClient = ["Mes incidents", "Mes vélos", "Scanner"];

  showDeclarationIncidentPage() {
    Get.to(() => IncidentDeclaration());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: loginController.isLogin.value
            ? GlobalStyles.backgroundLightGrey
            : GlobalStyles.loginBackground,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 65.0,
          elevation: 0,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          title: Obx(() {
            return Text(
              loginController.isLogin.value
                  ? tabTitleUser[navigationController.currentIndex.value]
                  : "VelyVelo",
              style: TextStyle(
                  color: GlobalStyles.greyTitle,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            );
          }),
          leading: Container(
            margin: EdgeInsets.only(left: 15.0),
            child: SvgPicture.asset("assets/logo.svg",
                height: 15.0, width: 15.0, fit: BoxFit.scaleDown),
          ),
          actions: <Widget>[
            Obx(() {
              return loginController.isLogin.value
                  ? GestureDetector(
                      onTap: () => loginController.logoutUser(),
                      child: PopupMenuButton(
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: GlobalStyles.greyTitle,
                        ),
                        onSelected: (result) {
                          if (result == 1) loginController.logoutUser();
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: GlobalStyles.purple,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(loginController.userName),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: GlobalStyles.greyTitle,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Se déconnecter"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox();
            }),
            const SizedBox(width: 15.0)
          ],
          // actions: [
          //   Obx(() {
          //     return loginController.isLogin.value
          //         ? GestureDetector(
          //             onTap: () => loginController.logoutUser(),
          //             child: Icon(
          //               Icons.logout,
          //               color: GlobalStyles.greyTitle,
          //               size: 30.0,
          //             ),
          //           )
          //         : SizedBox();
          //   }),
          //   const SizedBox(width: 15.0)
          // ],
        ),
        body: Obx(() {
          if (loginController.isLogin.value) {
            return PageView(
              onPageChanged: (index) => navigationController.changePage(index),
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                IncidentsView(),
                MyBikesView(),
                // loginController.isLogin.value && !loginController.isUser.value
                //     ? ScanView()
                //     : MyBikeView(
                //         isFromScan: false,
                //       )
              ],
            );
          } else {
            return LoginView();
          }
        }),
        floatingActionButton: Obx(() {
          return Container(
              height: 75.0,
              width: 75.0,
              child: navigationController.currentIndex.value == 0 &&
                      loginController.isLogin.value
                  ? FloatingActionButton(
                      backgroundColor: GlobalStyles.backgroundDarkGrey,
                      onPressed: () => showDeclarationIncidentPage(),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
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
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                unselectedItemColor: GlobalStyles.greyBottomBarText,
                unselectedIconTheme: IconThemeData(
                    color: GlobalStyles.greyUnselectedIcon, size: 25.0),
                unselectedLabelStyle: TextStyle(
                    color: GlobalStyles.greyBottomBarText,
                    fontSize: 16.0,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Icon(CupertinoIcons.wrench)),
                      label: "Incidents"),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Icon(Icons.map_outlined),
                      ),
                      label: "Mes vélos"),
                  // BottomNavigationBarItem(
                  //     icon: Padding(
                  //         padding: EdgeInsets.symmetric(vertical: 8.0),
                  //         child: loginController.isClient.value ||
                  //                 !loginController.isUser.value
                  //             ? Icon(CupertinoIcons.viewfinder)
                  //             : Icon(Icons.pedal_bike)),
                  //     label: loginController.isClient.value ||
                  //             !loginController.isUser.value
                  //         ? "Scanner"
                  //         : "Mon vélo")
                ]);
          } else {
            return SizedBox();
          }
        }));
  }
}
