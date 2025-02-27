// import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
// import 'package:Coretext/module/user_profile/model/user_data_model.dart';
// import 'package:Coretext/module/user_profile/view_model/user_data_view_model.dart';
// import 'package:Coretext/utils/WebService/api_base_model.dart';
// import 'package:Coretext/utils/bottom_bar_widget/view_model/bottom_bar_view-model.dart';
// import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
// import 'package:Coretext/utils/common_widgets/profile_row_widget.dart';
// import 'package:Coretext/utils/common_widgets/user_drawer.dart';
// import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
// import 'package:Coretext/utils/internet_connectivity.dart';
// import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
// import 'package:Coretext/utils/loader.dart';
// import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
// import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());
//   LoginViewModel loginViewModel = Get.put(LoginViewModel());
//   FocusNode firstFieldFocusNode = FocusNode();
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       showLoadingDialog();
//       await userDataViewModel.getUsersDetails();
//       loginViewModel.initializeSelectedState(userDataViewModel
//           .userListDataModel.value?.responseBody?.first?.state);
//       hideLoadingDialog();
//     });

//     super.initState();
//     checkConnectivity();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () {
//         final bottomBarVisibility =
//             Get.find<NavigationController>().showBottomBar.value;
//         return SafeArea(
//           child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             backgroundColor: bodyBGColor,
//             // appBar:
//             // const CustomAppBar(
//             //   containerText: "PROFILE",
//             //   imagePath: "assets/Icon/icon-(2).png",
//             // ),
//             drawer: const UserDrawer(),
//             body: InternetAwareWidget(
//               child: Obx(
//                 () => Stack(
//                   alignment: Alignment.topCenter,
//                   children: [
//                     SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Stack(
//                             alignment: Alignment.topCenter,
//                             children: [
//                               Card(
//                                 margin: const EdgeInsets.only(top: 70.0),
//                                 elevation: 5,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(10.0),
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.85,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       spaceWidget(height: 50.0),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           spaceWidget(width: 50.0),
//                                           Text(
//                                               userDataViewModel
//                                                       .userListDataModel
//                                                       .value
//                                                       ?.responseBody
//                                                       ?.first
//                                                       ?.firstName ??
//                                                   '',
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 20.0,
//                                               )),
//                                           IconButton(
//                                             onPressed: () {
//                                               userDataViewModel
//                                                       .isEditClick.value =
//                                                   !userDataViewModel
//                                                       .isEditClick.value;
//                                             },
//                                             icon: Icon(Icons.edit),
//                                           )
//                                         ],
//                                       ),
//                                       SingleChildScrollView(
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16.0),
//                                           child: Column(
//                                             children: [
//                                               ProfileRowWidget(
//                                                 label: "First Name",
//                                                 controller: loginViewModel
//                                                     .firstNameController
//                                                   ..text = userDataViewModel
//                                                           .userListDataModel
//                                                           .value
//                                                           ?.responseBody
//                                                           ?.first
//                                                           ?.firstName ??
//                                                       "",
//                                                 isEditable: userDataViewModel
//                                                     .isEditClick.value,
//                                                 isEmailField: false,
//                                                 isMobileField: false,
//                                                 isDropdown: false,
//                                                 focusNode: firstFieldFocusNode,
//                                               ),
//                                               const Divider(
//                                                   height: 1.0, thickness: 1.0),
//                                               ProfileRowWidget(
//                                                 label: "Last Name",
//                                                 controller: loginViewModel
//                                                     .lastNameController
//                                                   ..text = userDataViewModel
//                                                           .userListDataModel
//                                                           .value
//                                                           ?.responseBody
//                                                           ?.first
//                                                           ?.lastName ??
//                                                       "",
//                                                 isEditable: userDataViewModel
//                                                     .isEditClick.value,
//                                                 isEmailField: false,
//                                                 isMobileField: false,
//                                                 isDropdown: false,
//                                               ),
//                                               const Divider(
//                                                   height: 1.0, thickness: 1.0),
//                                               ProfileRowWidget(
//                                                 label: "Mobile",
//                                                 controller: loginViewModel
//                                                     .mobileNumberController
//                                                   ..text = userDataViewModel
//                                                           .userListDataModel
//                                                           .value
//                                                           ?.responseBody
//                                                           ?.first
//                                                           ?.mobile ??
//                                                       "",
//                                                 isEditable: userDataViewModel
//                                                     .isEditClick.value,
//                                                 isMobileField: true,
//                                                 isEmailField: false,
//                                                 isDropdown: false,
//                                               ),
//                                               const Divider(
//                                                   height: 1.0, thickness: 1.0),
//                                               ProfileRowWidget(
//                                                 maxLines: 2,
//                                                 label: "Email",
//                                                 controller: loginViewModel
//                                                     .emailController
//                                                   ..text = userDataViewModel
//                                                           .userListDataModel
//                                                           .value
//                                                           ?.responseBody
//                                                           ?.first
//                                                           ?.email ??
//                                                       "",
//                                                 isEditable: userDataViewModel
//                                                     .isEditClick.value,
//                                                 isEmailField: true,
//                                                 isMobileField: false,
//                                                 isDropdown: false,
//                                               ),
//                                               const Divider(
//                                                   height: 1.0, thickness: 1.0),
//                                               ProfileRowWidget(
//                                                 label: "City",
//                                                 controller: loginViewModel
//                                                     .cityController
//                                                   ..text = userDataViewModel
//                                                           .userListDataModel
//                                                           .value
//                                                           ?.responseBody
//                                                           ?.first
//                                                           ?.city ??
//                                                       "",
//                                                 isEditable: userDataViewModel
//                                                     .isEditClick.value,
//                                                 isEmailField: false,
//                                                 isMobileField: false,
//                                                 isDropdown: false,
//                                               ),
//                                               const Divider(
//                                                   height: 1.0, thickness: 1.0),
//                                               ProfileRowWidget(
//                                                 label: "District",
//                                                 controller: loginViewModel
//                                                     .disctrictController
//                                                   ..text = userDataViewModel
//                                                           .userListDataModel
//                                                           .value
//                                                           ?.responseBody
//                                                           ?.first
//                                                           ?.district ??
//                                                       "",
//                                                 isEditable: userDataViewModel
//                                                     .isEditClick.value,
//                                                 isEmailField: false,
//                                                 isMobileField: false,
//                                                 isDropdown: false,
//                                               ),
//                                               // const Divider(
//                                               //     height: 1.0, thickness: 1.0),
//                                               // ProfileRowWidget(
//                                               //   label: "State",
//                                               //   controller: loginViewModel
//                                               //       .stateController,
//                                               //   isEditable: userDataViewModel
//                                               //       .isEditClick
//                                               //       .value, // This controls whether the field is editable
//                                               //   isEmailField: false,
//                                               //   isMobileField: false,
//                                               //   isDropdown: true,
//                                               //   dropdownItems: loginViewModel
//                                               //       .states, // List of states
//                                               //   dropdownValue: loginViewModel
//                                               //               .selectedState
//                                               //               .value
//                                               //               ?.isNotEmpty ==
//                                               //           true
//                                               //       ? loginViewModel
//                                               //           .selectedState.value
//                                               //       : loginViewModel
//                                               //           .stateController.text,
//                                               //   onDropdownChanged: (value) {
//                                               //     if (value != null) {
//                                               //       loginViewModel.selectedState
//                                               //           .value = value;
//                                               //       loginViewModel
//                                               //           .stateController
//                                               //           .text = loginViewModel
//                                               //               .selectedState
//                                               //               .value ??
//                                               //           "-";
//                                               //     }
//                                               //   },
//                                               // ),
//                                               const Divider(
//                                                   height: 1.0, thickness: 1.0),
//                                               ProfileRowWidget(
//                                                 label: "Pin code",
//                                                 controller: loginViewModel
//                                                     .zipcodeController
//                                                   ..text = (userDataViewModel
//                                                               .userListDataModel
//                                                               .value
//                                                               ?.responseBody
//                                                               ?.first
//                                                               ?.pinCode ??
//                                                           0)
//                                                       .toString(),
//                                                 isEditable: userDataViewModel
//                                                     .isEditClick.value,
//                                                 isEmailField: false,
//                                                 isMobileField: false,
//                                                 isDropdown: false,
//                                               ),
//                                               // const Divider(
//                                               //     height: 1.0, thickness: 1.0),
//                                               // ProfileRowWidget(
//                                               //   label:
//                                               //       "Educational \nQualification",
//                                               //   controller: loginViewModel
//                                               //       .educationalQualificationController
//                                               //     ..text = userDataViewModel
//                                               //             .userListDataModel
//                                               //             .value
//                                               //             ?.responseBody
//                                               //             ?.first
//                                               //             ?.education ??
//                                               //         "Post Graduation",
//                                               //   isEditable: userDataViewModel
//                                               //       .isEditClick.value,
//                                               //   isEmailField: false,
//                                               //   isMobileField: false,
//                                               //   isDropdown: false,
//                                               //   // maxLines: 2,
//                                               // ),
//                                               if (userDataViewModel
//                                                   .isEditClick.value)
//                                                 ElevatedButton(
//                                                   onPressed: () async {
//                                                     FocusScope.of(context)
//                                                         .unfocus();

//                                                     // Save the updated information here
//                                                     userDataViewModel
//                                                         .isEditClick
//                                                         .value = false;
//                                                     // You can call the save function of your ViewModel here
//                                                     APIBaseModel<
//                                                             UserDataModel?>?
//                                                         response =
//                                                         await userDataViewModel
//                                                             .updateUserDetails();
//                                                     if (response?.status ==
//                                                         true) {
//                                                       userDataViewModel
//                                                           .getUsersDetails();
//                                                     }
//                                                   },
//                                                   style: ButtonStyle(
//                                                     splashFactory:
//                                                         InkRipple.splashFactory,
//                                                     overlayColor:
//                                                         MaterialStateProperty
//                                                             .resolveWith(
//                                                       (states) {
//                                                         return states.contains(
//                                                                 MaterialState
//                                                                     .pressed)
//                                                             ? Colors.grey
//                                                             : null;
//                                                       },
//                                                     ),
//                                                     backgroundColor:
//                                                         MaterialStateProperty
//                                                             .all(primaryColor),
//                                                     shape: MaterialStateProperty
//                                                         .all<
//                                                             RoundedRectangleBorder>(
//                                                       RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                                 10.0), // Set to 0 for square shape
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   child: const ConstantText(
//                                                     text: "Save",
//                                                     color: Colors.black,
//                                                     fontSize: 14.0,
//                                                   ),
//                                                 ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const CircleAvatar(
//                                 backgroundColor: Colors.transparent,
//                                 radius: 70,
//                                 backgroundImage: AssetImage(
//                                     'assets/Profile/yellow_logo.png'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             bottomNavigationBar:
//                 bottomBarVisibility ? CustomBottomNavBar() : null,
//           ),
//         );
//       },
//     );
//   }
// }
