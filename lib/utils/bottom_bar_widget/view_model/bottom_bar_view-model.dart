import 'package:get/get.dart';

class NavigationController extends GetxController {
  // RxBool to manage the visibility state
  var showBottomBar = true.obs;

  // Method to update the visibility
  void setBottomBarVisibility(bool isVisible) {
    showBottomBar.value = isVisible;
  }
}
