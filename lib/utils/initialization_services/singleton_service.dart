import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/auth_module/signup/view_model/signup_view_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class CoreTextAppGlobal {
  CoreTextAppGlobal._privateConstructor();

  static CoreTextAppGlobal instance = CoreTextAppGlobal._privateConstructor();

  SharedPreferences? preferences;

  final LoginViewModel loginViewModel = Get.put(LoginViewModel());
  final SignupViewModel signupViewModel = Get.put(SignupViewModel());

  RxInt bottomNavigationBarSelectedIndex = 1.obs;
  RxInt appNavigationBarSelectedIndex = 0.obs;
  
  void setBottomNavigationBarSelectedIndex() {}

  // Method to check if the token is saved
  bool isTokenSaved() {
    return preferences?.containsKey('token') ?? false;
  }
}
