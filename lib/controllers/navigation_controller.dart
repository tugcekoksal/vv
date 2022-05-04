// Vendor
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changePage(index) {
    currentIndex.value = index;
  }
}
