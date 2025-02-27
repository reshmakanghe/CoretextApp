import 'dart:convert';

import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/auth_module/signup/model/signup_data_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/WebService/api_service.dart';
import 'package:Coretext/utils/WebService/end_points_constant.dart';
import 'package:Coretext/utils/constants/StringConstants/key_value_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SignupViewModel extends GetxController {
  Rx<APIBaseModel<SignUpDataModel?>?>? signupDataModel =
      RxNullable<APIBaseModel<SignUpDataModel?>?>().setNull();

  LoginViewModel loginViewModel = Get.put(LoginViewModel());

  // final formKey = GlobalKey<FormState>();
  // var isFormValid = false.obs;

  String? selectedCountryName;

  var selectedState = RxnString();

  String timezone2 = "";
  DateTime dateTime = DateTime.now();

  get isSubmitted => null;

  // void submit() {
  //   isSubmitted.value = true;
  // }

  //sign up with secure code
  Future<APIBaseModel<SignUpDataModel?>?>? signUp(
      {String? appSignature, String? gID, String? userId}) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    print(deviceToken);
    String selectedState = loginViewModel.selectedState.value ?? '';

    signupDataModel?.value =
        await APIService.postDataToServer<SignUpDataModel?>(
            endPoint: signupEndPoint,
            body: {
              "first_name": loginViewModel.firstNameController.text,
              "last_name": loginViewModel.lastNameController.text,
              "email": loginViewModel.emailController.text,
              "mobile": loginViewModel.mobileNumberController.text,
              "role": "user",
              "city": loginViewModel.cityController.text,

              // "district": loginViewModel.disctrictController.text,
              "state": selectedState,
              "pin_code": loginViewModel.zipcodeController.text,
              "fcm_token": deviceToken,
              "user_id": userId
              //"google_id": gID ?? ""
              //  "mobileSignature": appSignature
            },
            create: (dynamic json) {
              return SignUpDataModel.fromJson(json);
            });

    return signupDataModel?.value;
  }

  Future<void> storeSignupResponseInSharedPreferences() async {
    print(
        "Token--------------->${signupDataModel?.value?.responseBody?.token}");
    if (signupDataModel?.value?.status == true) {
      await CoreTextAppGlobal.instance.preferences?.setString(
          signupSession,
          jsonEncode(signupDataModel?.value?.toJson(
                      signupDataModel?.value?.responseBody?.toJson()) ??
                  {}
              // signupDataModel?.value
              //     ?.toJson((json) => json as Map<String, dynamic>),
              ));
    }
    return;
  }

  bool checkForLoginSessionExists() {
    String? signupSessionValue =
        CoreTextAppGlobal.instance.preferences?.getString(signupSession);
    print("Respnse ----------------->$signupSessionValue");
    if (signupSessionValue != null) {
      CoreTextAppGlobal.instance.signupViewModel.signupDataModel?.value =
          APIBaseModel.fromJson(
        jsonDecode(signupSessionValue),
        true,
        (json) {
          return SignUpDataModel.fromJson(json);
        },
      );
      return true;
    } else {
      return false;
    }
  }
}
