import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/user_profile/model/user_data_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/WebService/api_service.dart';
import 'package:Coretext/utils/WebService/end_points_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class UserDataViewModel extends GetxController {
  RxBool isEditClick = false.obs;
  RxList<int> selectedSpecialities = <int>[].obs;
  RxString isDoctor = ''.obs;

  Rx<APIBaseModel<UserDataModel?>?>? userDataModel =
      RxNullable<APIBaseModel<UserDataModel?>?>().setNull();

  Rx<APIBaseModel<List<UserDataModel?>?>?> userListDataModel =
      RxNullable<APIBaseModel<List<UserDataModel?>?>?>().setNull();

  LoginViewModel loginViewModel = Get.put(LoginViewModel());

  //get user details
  Future<APIBaseModel<List<UserDataModel?>?>?> getUsersDetails() async {
    final int userId = CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? 0;
    userListDataModel.value =
        await APIService.getDataFromServer<List<UserDataModel?>?>(
      endPoint: userEndPoint(userId: userId),
      create: (dynamic json) {
        try {
          return (json as List).map((e) => UserDataModel.fromJson(e)).toList();
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      },
    );
    print(
        "User ID: ${CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? 0}");
    return userListDataModel.value;
  }

  //this is use for splash screen without error message in flutter toast
  Future<APIBaseModel<List<UserDataModel?>?>?> getUsersDetailsForSplashScreen() async {
    final int userId = CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? 0;
    userListDataModel.value = await APIService
        .getDataFromServerWithoutErrorModel<List<UserDataModel?>?>(
      endPoint: userEndPoint(userId: userId),
      create: (dynamic json) {
        try {
          return (json as List).map((e) => UserDataModel.fromJson(e)).toList();
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      },
    );
    print(
        "User ID: ${CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.userId ?? 0}");
    return userListDataModel.value;
  }

  //Update user details
 Future<APIBaseModel<UserDataModel?>?>? updateUserDetails() async {
  int isIntDoctor = loginViewModel.doctorController.text == "Yes" ? 1 : 0;

  // Create the base body map
  Map<String, dynamic> body = {
    "first_name": loginViewModel.firstNameController.text,
    "last_name": loginViewModel.lastNameController.text,
    "is_doctor": isIntDoctor,
    "state": loginViewModel.selectedState.value,
    "speciality": loginViewModel.specialityController.text,
  };

  if(loginViewModel.mobileNumberController.text.length == 10 ){
    body["mobile"]= loginViewModel.mobileNumberController.text;
  }
  // Check if selectedSpecialities is empty
  if (loginViewModel.selectedSpecialities.isNotEmpty) {
    // Add cat_id only if there are selected specialities
    body["cat_id"] = loginViewModel.selectedSpecialities.toList().toString(); // Create a comma-separated string
  }

  // Send the request to update user details
  userDataModel?.value = await APIService.patchDataToServer<UserDataModel?>(
    endPoint: updateUserProfile,
    body: body,
    create: (dynamic json) {
      return UserDataModel.fromJson(json);
    },
  );

  print(userDataModel?.value?.message);
  return userDataModel?.value;
}

}
          // "city": loginViewModel.cityController.text,
          // "district": loginViewModel.disctrictController.text,
          //  "mobileSignature": appSignature
          // "email": loginViewModel.emailController.text,
