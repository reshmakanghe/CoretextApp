import 'dart:convert';

import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/privacypolicy.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/view_model/speciality_view_model.dart';
import 'package:Coretext/module/terms&conditions.dart';
import 'package:Coretext/module/user_profile/model/user_data_model.dart';
import 'package:Coretext/module/user_profile/view_model/user_data_view_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
import 'package:Coretext/utils/common_widgets/user_profile_widget.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());
  LoginViewModel loginViewModel = Get.put(LoginViewModel());
  TextEditingController selectedSpecialities =
      TextEditingController(); // Change this to manage user interests
  SpecialityViewModel specialityViewModel = Get.put(SpecialityViewModel());
  final List<String> doctorOptions = ["Yes", "No"]; // Replace with your options
  DateTime? _lastBackPressTime;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showLoadingDialog();
      await userDataViewModel.getUsersDetails();
      loginViewModel.initializeSelectedState(userDataViewModel
          .userListDataModel.value?.responseBody?.first?.state);
      await specialityViewModel.fetchSpecialties();
      hideLoadingDialog();
      // Initialize the controller text with user interests
    });
    super.initState();
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 1)) {
          // If the last back press time is null or more than 1 second has passed
          _lastBackPressTime = now; // Update last back press time
          // Show a message to indicate double tap to exit
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Double tap to exit the app'),
              duration: Duration(seconds: 2),
            ),
          );
          return false; // Do not pop the route
        }
        return true; // Exit the app
      },
      child: SafeArea(
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Obx(() {
                loginViewModel.doctorController.text = (userDataViewModel
                            .userListDataModel
                            .value
                            ?.responseBody
                            ?.first
                            ?.isDoctor ==
                        1)
                    ? "Yes"
                    : "No";
                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: primaryColor, // Set blue color
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 24
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 24
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 22
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 20
                                                            :19,
                              ),
                              Image.asset(
                                "assets/images/new/icons resize-10.png",
                                fit: BoxFit.fitHeight,
                                height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 120
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 120
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 100
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 100
                                                            :90,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(
                                    "User Profile",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 22
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 22
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 20
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 19
                                                            :18,
                                    ),
                                  ),
                                  spaceWidget(width: 10.0),
                                  CircleAvatar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 219, 114, 21),
                                    radius: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 20
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 20
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 18
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 16
                                                            :16,  // Adjust the radius as needed
                                    child: IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.white),
                                      iconSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 22
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 22
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 20
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 18
                                                            :17,
                                      onPressed: () {
                                        userDataViewModel.isEditClick.value =
                                            !userDataViewModel
                                                .isEditClick.value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        ),

                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Obx(() {
                                    // Set the initial value in the controller if it's empty
                                    if (loginViewModel
                                        .firstNameController.text.isEmpty) {
                                      loginViewModel.firstNameController.text =
                                          userDataViewModel
                                                  .userListDataModel
                                                  .value
                                                  ?.responseBody
                                                  ?.first
                                                  ?.firstName ??
                                              "";
                                    }

                                    return UserProfileWidget(
                                      image: const AssetImage(
                                          'assets/images/photo_16611670.png'),
                                      controller:
                                          loginViewModel.firstNameController,
                                      isEditable:
                                          userDataViewModel.isEditClick.value,
                                      isEmailField: false,
                                      isDropdown: false,
                                      editableFieldColor: Colors.black,
                                      hintText: "First Name",
                                    );
                                  }),
                                ),
                                // First Name
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 50.0),
                                //   child: UserProfileWidget(
                                //     image: const AssetImage(
                                //         'assets/images/photo_16611670.png'),
                                //     controller:
                                //         loginViewModel.firstNameController
                                //           ..text = userDataViewModel
                                //                   .userListDataModel
                                //                   .value
                                //                   ?.responseBody
                                //                   ?.first
                                //                   ?.firstName ??
                                //               "",
                                //     isEditable:
                                //         userDataViewModel.isEditClick.value,
                                //     isEmailField: false,
                                //     isDropdown: false,
                                //     editableFieldColor: Colors.black,
                                //     hintText: "First Name",
                                //     // isMySpecialty: false,
                                //   ),
                                // ),
                                // // Last Name
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 50.0),
                                //   child: UserProfileWidget(
                                //     image: const AssetImage(
                                //         'assets/images/photo_16611670.png'),
                                //     controller:
                                //         loginViewModel.lastNameController
                                //           ..text = userDataViewModel
                                //                   .userListDataModel
                                //                   .value
                                //                   ?.responseBody
                                //                   ?.first
                                //                   ?.lastName ??
                                //               "",
                                //     isEditable:
                                //         userDataViewModel.isEditClick.value,
                                //     isEmailField: false,
                                //     isDropdown: false,
                                //     editableFieldColor: Colors.black,
                                //     hintText: "Last Name",
                                //     // isMySpecialty: false,
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Obx(() {
                                    // Set the initial value in the controller if it's empty
                                    if (loginViewModel
                                        .lastNameController.text.isEmpty) {
                                      loginViewModel.lastNameController.text =
                                          userDataViewModel
                                                  .userListDataModel
                                                  .value
                                                  ?.responseBody
                                                  ?.first
                                                  ?.lastName ??
                                              "";
                                    }

                                    return UserProfileWidget(
                                      image: const AssetImage(
                                          'assets/images/photo_16611670.png'),
                                      controller:
                                          loginViewModel.lastNameController,
                                      isEditable:
                                          userDataViewModel.isEditClick.value,
                                      isEmailField: false,
                                      isDropdown: false,
                                      editableFieldColor: Colors.black,
                                      hintText: "Last Name",
                                    );
                                  }),
                                ),
                                // Email
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: UserProfileWidget(
                                    image: const AssetImage(
                                        'assets/images/email_3747019.png'),
                                    controller: loginViewModel.emailController
                                      ..text = userDataViewModel
                                              .userListDataModel
                                              .value
                                              ?.responseBody
                                              ?.first
                                              ?.email ??
                                          "",
                                    isEditable: userDataViewModel.isEditClick
                                        .value, // Email should not be editable
                                    isEmailField: true,
                                    isDropdown: false,
                                    editableFieldColor: Colors.grey,
                                    // isMySpecialty: false,
                                  ),
                                ),
                                // Mobile Number
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    child: Obx(() {
                                      // Set the initial value in the controller if it's empty
                                      if (loginViewModel.mobileNumberController
                                          .text.isEmpty) {
                                        loginViewModel.mobileNumberController
                                            .text = userDataViewModel
                                                .userListDataModel
                                                .value
                                                ?.responseBody
                                                ?.first
                                                ?.mobile ??
                                            "";
                                      }

                                      return UserProfileWidget(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        image: const AssetImage(
                                            'assets/images/smartphone_3694647.png'),
                                        controller: loginViewModel
                                            .mobileNumberController,
                                        // loginViewModel
                                        //     .mobileNumberController
                                        //   ..text = userDataViewModel
                                        //           .userListDataModel
                                        //           .value
                                        //           ?.responseBody
                                        //           ?.first
                                        //           ?.mobile ??
                                        //       "",
                                        isEditable:
                                            userDataViewModel.isEditClick.value,
                                        isEmailField: false,
                                        isMobileField: true,
                                        isDropdown: false,
                                        editableFieldColor: Colors.black,
                                        hintText: "Mobile Number",
                                      );
                                    })),
                                // Speciality
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: UserProfileWidget(
                                    image: const AssetImage(
                                        'assets/images/doctor_1979869.png'),
                                    controller: loginViewModel.doctorController
                                      ..text = (userDataViewModel
                                                  .userListDataModel
                                                  .value
                                                  ?.responseBody
                                                  ?.first
                                                  ?.isDoctor ==
                                              1
                                          ? "Yes"
                                          : "No"),
                                    isEditable:
                                        userDataViewModel.isEditClick.value,
                                    isEmailField: false,
                                    hintText: "Yes or No",
                                    isDropdown: true,
                                    editableFieldColor: Colors.black,
                                    dropdownItems:
                                        doctorOptions, // List of options
                                    dropdownValue: (userDataViewModel
                                                .userListDataModel
                                                .value
                                                ?.responseBody
                                                ?.first
                                                ?.isDoctor ==
                                            1)
                                        ? "Yes"
                                        : "No",
                                    onDropdownChanged: (value) {
                                      // Update only if editing
                                      if (userDataViewModel.isEditClick.value) {
                                        if (value == "Yes") {
                                          loginViewModel.isDoctor.value =
                                              '1'; // Set to '1' if Yes
                                          loginViewModel.doctorController.text =
                                              "Yes";
                                        } else {
                                          loginViewModel.isDoctor.value =
                                              '0'; // Set to '0' if No
                                          loginViewModel.doctorController.text =
                                              "No";
                                        }
                                      }
                                    },
                                    textStyle: const TextStyle(
                                      fontFamily: 'Montserrat-SemiBold.ttf',
                                    ),
                                  ),
                                ),

                                // Location Dropdown
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: UserProfileWidget(
                                    image: const AssetImage(
                                        'assets/images/gps_13953734.png'),
                                    controller: loginViewModel.stateController
                                      ..text = userDataViewModel
                                              .userListDataModel
                                              .value
                                              ?.responseBody
                                              ?.first
                                              ?.state ??
                                          "",
                                    isEditable:
                                        userDataViewModel.isEditClick.value,
                                    isEmailField: false,
                                    isDropdown: true,
                                    hintText: "Select State",
                                    dropdownItems: loginViewModel.states,
                                    dropdownValue: loginViewModel.selectedState
                                                .value?.isNotEmpty ==
                                            true
                                        ? loginViewModel.selectedState.value
                                        : loginViewModel.stateController.text,
                                    onDropdownChanged: (value) {
                                      if (value != null) {
                                        loginViewModel.selectedState.value =
                                            value;
                                        loginViewModel.stateController.text =
                                            loginViewModel.selectedState.value;
                                      }
                                    },
                                    editableFieldColor: Colors.black,
                                    // isMySpecialty: false,
                                  ),
                                ),
                                // Speciality
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Obx(() {
                                    // Determine if the user is a doctor
                                    bool isDoctor =
                                        loginViewModel.isDoctor.value == '1';

                                    // Get the speciality text
                                    String specialityText = userDataViewModel
                                            .userListDataModel
                                            .value
                                            ?.responseBody
                                            ?.first
                                            ?.speciality ??
                                        "";

                                    // Determine if the user is not a doctor
                                    bool isNotDoctor = userDataViewModel
                                            .userListDataModel
                                            .value
                                            ?.responseBody
                                            ?.first
                                            ?.isDoctor ==
                                        0;

                                    // Set the initial value in the controller if it's empty
                                    if (loginViewModel
                                        .specialityController.text.isEmpty) {
                                      loginViewModel.specialityController.text =
                                          specialityText;
                                    }

                                    // Return the appropriate widget based on the conditions
                                    if (isDoctor || !isNotDoctor) {
                                      return UserProfileWidget(
                                        image: const AssetImage(
                                            'assets/images/favorite_14866738.png'),
                                        controller:
                                            loginViewModel.specialityController,
                                        isEditable:
                                            userDataViewModel.isEditClick.value,
                                        isEmailField: false,
                                        isDropdown: false,
                                        editableFieldColor: Colors.black,
                                        hintText: "Speciality",
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }),
                                ),

                                // Obx(
                                //   () {
                                //     // Determine if the user is a doctor
                                //     bool isDoctor =
                                //         loginViewModel.isDoctor.value == '1';

                                //     // Get the speciality text
                                //     String specialityText = userDataViewModel
                                //             .userListDataModel
                                //             .value
                                //             ?.responseBody
                                //             ?.first
                                //             ?.speciality ??
                                //         "";

                                //     // Determine if the user is not a doctor
                                //     bool isNotDoctor = userDataViewModel
                                //             .userListDataModel
                                //             .value
                                //             ?.responseBody
                                //             ?.first
                                //             ?.isDoctor ==
                                //         0;

                                //     // Return the appropriate widget based on the conditions
                                //     if (isDoctor || !isNotDoctor) {
                                //       return Padding(
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 50.0),
                                //         child: UserProfileWidget(
                                //           image: const AssetImage(
                                //               'assets/images/favorite_14866738.png'),
                                //           controller: loginViewModel
                                //               .specialityController
                                //             ..text = specialityText,
                                //           isEditable: userDataViewModel
                                //               .isEditClick.value,
                                //           isEmailField: false,
                                //           isDropdown: false,
                                //           editableFieldColor: Colors.black,
                                //           hintText: "Speciality",
                                //         ),
                                //       );
                                //     } else {
                                //       return const SizedBox.shrink();
                                //     }
                                //   },
                                // ),
                                // // Return an empty widget if the condition is false
                                // Favorite Icon
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: UserProfileWidget(
                                    image: const AssetImage(
                                        'assets/images/favorite_14866738.png'),
                                    controller: selectedSpecialities
                                      ..text = userDataViewModel
                                              .userListDataModel
                                              .value
                                              ?.responseBody
                                              ?.first
                                              ?.userInterest
                                              ?.map((interest) =>
                                                  interest.catName ?? "")
                                              .join(", ") ??
                                          "",
                                    isEditable:
                                        userDataViewModel.isEditClick.value,
                                    isEmailField: false,
                                    hintText: "My Interest",
                                    isDropdown: false,
                                    editableFieldColor: Colors.black,
                                    myInterest: true,
                                    dropdownValue: loginViewModel
                                            .selectedSpecialities.isEmpty
                                        ? "My Interest"
                                        : loginViewModel.selectedSpecialities
                                            .map((id) => specialityViewModel
                                                .specialties
                                                .firstWhere((speciality) =>
                                                    speciality.catId == id)
                                                .catName)
                                            .join(", "),
                                    onDropdownChanged: (selectedName) {
                                      if (selectedName != null) {
                                        final selectedId = specialityViewModel
                                            .specialties
                                            .firstWhere((speciality) =>
                                                speciality.catName ==
                                                selectedName)
                                            .catId;
                                        // Ensure that the selectedId is an int and assign it to the selectedSpecialities list
                                        if (!loginViewModel.selectedSpecialities
                                            .contains(selectedId)) {
                                          loginViewModel.selectedSpecialities
                                              .add(selectedId!);
                                        }
                                        loginViewModel
                                                .specialityController.text =
                                            loginViewModel.selectedSpecialities
                                                .map((id) => specialityViewModel
                                                    .specialties
                                                    .firstWhere((speciality) =>
                                                        speciality.catId == id)
                                                    .catName)
                                                .join(", ");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 20), // Space before the save button
                        if (userDataViewModel.isEditClick.value)
                          ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              // Save the updated information
                              userDataViewModel.isEditClick.value = false;
                              showLoadingDialog();
                              APIBaseModel<UserDataModel?>? response =
                                  await userDataViewModel.updateUserDetails();
                              hideLoadingDialog();
                              if (response?.status == true) {
                                showLoadingDialog();
                                userDataViewModel.getUsersDetails();
                                hideLoadingDialog();
                              }
                            },
                            style: ButtonStyle(
                              splashFactory: InkRipple.splashFactory,
                              overlayColor: MaterialStateProperty.resolveWith(
                                (states) {
                                  return states.contains(MaterialState.pressed)
                                      ? Colors.grey
                                      : null;
                                },
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.deepOrange,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30.0), // Set to 0 for square shape
                                ),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                        SizedBox(
                          height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 10
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 10
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 10
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 9
                                                            :8,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showPrivacyPolicyDialog(context);
                          },
                          child:  Text(
                            'Privacy Policy',
                            style: TextStyle(fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 13
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 13
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 11
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 11
                                                            :10,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 10
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 10
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 10
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 9
                                                            :8,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showTermsnConditionsDialog(context);
                          },
                          child:  Text(
                            'Terms & Conditions',
                            style:
                                TextStyle(fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 13
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 13
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 11
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 11
                                                            :10,decoration: TextDecoration.underline),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 10
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 10
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 10
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 9
                                                            :8,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showRatingDialog(context);
                          },
                          child:  Text(
                            'Rate App',
                            style:
                                TextStyle(fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 13
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 13
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 11
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 11
                                                            :10,decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
          bottomNavigationBar: const CustomBottomNavBar(),
        ),
      ),
    );
  }

// Helper function to parse userInterest JSON and extract category names
  String _parseUserInterest(String userInterest) {
    if (userInterest.isEmpty) {
      return ""; // Return an empty string if userInterest is null or empty
    }

    try {
      // Parse the JSON string
      List<dynamic> parsedInterest = jsonDecode(userInterest);

      // Extract the category names and join them with a comma
      return parsedInterest
          .map((interest) => interest['cat_name'])
          .join(', '); // Example: "General Practice, Pediatrics"
    } catch (e) {
      // If parsing fails, return an empty string or handle the error appropriately
      print("Error parsing userInterest: $e");
      return "";
    }
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    String privacyPolicy = '''
Privacy Policy

Effective Date: [Insert Date]

1. Introduction
Welcome to [Your Company Name] (“we,” “our,” or “us”). Your privacy is important to us. This Privacy Policy outlines how we collect, use, disclose, and protect your personal information when you visit our website [insert website URL] or use our mobile application [insert app name].

2. Information We Collect
- **Personal Information:** We may collect personal information that you provide, such as your name, email address, and phone number.
- **Usage Data:** We automatically collect information about your interactions with our services, including your IP address, browser type, and pages visited.
- **Cookies:** We use cookies to enhance user experience. You can manage cookie preferences through your browser settings.

3. How We Use Your Information
We may use the information we collect for various purposes, including:
- To provide and maintain our services.
- To communicate with you, including sending updates and promotional materials.
- To analyze usage trends and improve our services.

4. Disclosure of Your Information
We may share your information with:
- **Service Providers:** Third parties who assist us in providing our services.
- **Legal Authorities:** If required by law or in response to valid legal requests.
- **Business Transfers:** In connection with any merger, acquisition, or asset sale.

5. Security of Your Information
We implement reasonable security measures to protect your information from unauthorized access and misuse. However, no method of transmission over the internet or electronic storage is completely secure.

6. Your Rights
You may have certain rights regarding your personal information, including:
- The right to access and obtain a copy of your personal data.
- The right to request correction of inaccurate or incomplete data.
- The right to request deletion of your personal data under certain conditions.

7. Changes to This Privacy Policy
We may update this Privacy Policy occasionally. We will notify you of any changes by posting the new policy on our website with an updated effective date.

8. Contact Us
If you have any questions about this Privacy Policy, please contact us at: 
[Your Company Name]  
[Your Address]  
[Your Email Address]  
[Your Phone Number]
''';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(privacyPolicy),
                // Add more text or widgets as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTermsnConditionsDialog(BuildContext context) {
    String privacyPolicy = '''
Terms and Conditions

Effective Date: [Insert Date]

1. Introduction
By accessing or using [Your App Name] (“we,” “our,” or “us”), you agree to comply with and be bound by these Terms and Conditions. Please read them carefully.

2. Use of Our Service
You agree to use our services in compliance with all applicable laws and regulations. You must not use our service for any unlawful or prohibited purpose.

3. Account Responsibility
You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device. You agree to accept responsibility for all activities that occur under your account.

4. Intellectual Property
All content included on the app, such as text, graphics, logos, and images, is the property of [Your Company Name] or its licensors and is protected by copyright and other laws.

5. Limitation of Liability
In no event shall [Your Company Name] be liable for any damages arising out of or in connection with the use of our app.

6. Governing Law
These Terms and Conditions are governed by and construed in accordance with the laws of [Insert Jurisdiction].

7. Changes to Terms
We may update these Terms and Conditions from time to time. Any changes will be posted on this page with an updated effective date.

8. Contact Us
If you have any questions about these Terms, please contact us at:
[Your Company Name]
''';

    bool isChecked = false; // Variable to track checkbox state

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Terms & Conditions'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(privacyPolicy),
                    const SizedBox(
                        height: 16), // Space between text and checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked =
                                  value ?? false; // Update checkbox state
                            });
                          },
                        ),
                        const Expanded(
                          child: Text('I agree to the Terms and Conditions'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: isChecked
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : null, // Disable button if checkbox is not checked
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context) {
    double _rating = 0; // Initial rating value
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate the App'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please select a rating:'),
                  const SizedBox(height: 16),
                  // Star rating row
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1; // Update rating instantly
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Rating: $_rating stars'),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You rated the app $_rating stars!')),
                );
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without submitting
              },
            ),
          ],
        );
      },
    );
  }
}
