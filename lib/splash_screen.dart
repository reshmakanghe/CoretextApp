import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/module/auth_module/login/screens/login_screen.dart';
import 'package:Coretext/module/auth_module/signup/screen/quick_signup_screen.dart';
import 'package:Coretext/module/auth_module/signup/screen/register_screen.dart';
import 'package:Coretext/module/user_profile/view_model/user_data_view_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';

import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CoreTextAppGlobal coreTextAppGLobal = CoreTextAppGlobal.instance;
  UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(seconds: 3));

      SharedPreferences.getInstance().then((value) async {
        coreTextAppGLobal.preferences = value;
        coreTextAppGLobal.loginViewModel.checkForLoginSessionExists();
        await userDataViewModel.getUsersDetailsForSplashScreen();
        Get.offAll(
          transition: Transition.noTransition,
          coreTextAppGLobal.loginViewModel.loginDataModel?.value == null
              ? LoginScreen()
              : ((userDataViewModel.userListDataModel.value?.responseBody?.first
                              ?.mobile ==
                          null) ||
                      userDataViewModel.userListDataModel.value?.responseBody
                              ?.first?.mobile?.isEmpty ==
                          true)
                  ? Register(
                      emailId: userDataViewModel.userListDataModel.value
                              ?.responseBody?.first?.email ??
                          "",
                      firstName: userDataViewModel.userListDataModel.value
                              ?.responseBody?.first?.firstName ??
                          "",
                      lastName: userDataViewModel.userListDataModel.value
                              ?.responseBody?.first?.lastName ??
                          "",
                      userId: userDataViewModel.userListDataModel.value
                              ?.responseBody?.first?.userId ??
                          0,
                    )
                  : ArticleScreen(articleHeading: ""),
        );
        // Get.offAll(
        //     coreTextAppGLobal.loginViewModel.loginDataModel?.value == null
        //         ? LoginScreen()
        //         //: BottomNavigationBarWidget(bodyWidget:
        //         : ((userDataViewModel
        //                         .userDataModel?.value?.responseBody?.mobile ==
        //                     null) ||
        //                 userDataViewModel.userDataModel?.value?.responseBody
        //                         ?.mobile?.isEmpty ==
        //                     true)
        //             ? Register(
        //                 emailId: coreTextAppGLobal.loginViewModel.loginDataModel
        //                         ?.value?.responseBody?.email ??
        //                     "",
        //                 firstName: coreTextAppGLobal.loginViewModel
        //                     .loginDataModel?.value?.responseBody?.firstName,
        //                 lastName: coreTextAppGLobal.loginViewModel
        //                     .loginDataModel?.value?.responseBody?.lastName,
        //                 userId: coreTextAppGLobal.loginViewModel.loginDataModel
        //                     ?.value?.responseBody?.userId,
        //               )
        //             : ArticleScreen(
        //                 articleHeading: "",
        //               )
        //     // )
        //     );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InternetAwareWidget(
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/Core Text Logo (1).png",

              fit: BoxFit.cover, // You can adjust the fit property as needed
            ),
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/Splash_screen/For Android/XXHDPI/Portrait-960x1600.gif"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
          ),
        ],
      ),
    ));
  }
}
// import 'dart:convert';
// import 'package:Coretext/module/article_module/screen/article_screen.dart';
// import 'package:Coretext/module/auth_module/login/screens/login_screen.dart';
// import 'package:Coretext/module/auth_module/signup/screen/register_screen.dart';
// import 'package:Coretext/module/user_profile/view_model/user_data_view_model.dart';
// import 'package:Coretext/utils/initialization_services/singleton_service.dart';
// import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:get/get.dart';

// // Assuming CoreTextAppGlobal and UserDataViewModel are defined elsewhere
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   CoreTextAppGlobal coreTextAppGLobal = CoreTextAppGlobal.instance;
//   UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await Future.delayed(Duration(seconds: 3));

//       SharedPreferences.getInstance().then((prefs) async {
//         coreTextAppGLobal.preferences = prefs;

//         // Check if the token exists
//         String? token =
//             prefs.getString('token'); // Replace 'token' with your actual key
//         if (token == null) {
//           // Clear local storage if the token is null
//           await prefs.clear();
//           print("No token found. Preferences cleared.");
//         }

//         // Check for login session
//         bool loginSessionExists =
//             coreTextAppGLobal.loginViewModel.checkForLoginSessionExists();
//         await userDataViewModel.getUsersDetailsForSplashScreen();

//         // Navigate based on the login session and user data
//         Get.offAll(
//           transition: Transition.noTransition,
//           loginSessionExists
//               ? ((userDataViewModel.userListDataModel.value?.responseBody?.first
//                               ?.mobile ==
//                           null) ||
//                       userDataViewModel.userListDataModel.value?.responseBody
//                               ?.first?.mobile?.isEmpty ==
//                           true)
//                   ? Register(
//                       emailId: userDataViewModel.userListDataModel.value
//                               ?.responseBody?.first?.email ??
//                           "",
//                       firstName: userDataViewModel.userListDataModel.value
//                               ?.responseBody?.first?.firstName ??
//                           "",
//                       lastName: userDataViewModel.userListDataModel.value
//                               ?.responseBody?.first?.lastName ??
//                           "",
//                       userId: userDataViewModel.userListDataModel.value
//                               ?.responseBody?.first?.userId ??
//                           0,
//                     )
//                   : ArticleScreen(articleHeading: "")
//               : LoginScreen(),
//         );
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: InternetAwareWidget(
//         child: Center(
//           child: Image.asset(
//             "assets/images/Core Text Logo (1).png",
//             fit: BoxFit.cover, // Adjust as needed
//           ),
//         ),
//       ),
//     );
//   }
// }
