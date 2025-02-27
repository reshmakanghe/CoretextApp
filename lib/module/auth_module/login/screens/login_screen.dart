import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/module/auth_module/login/model/login_data_model.dart';
import 'package:Coretext/module/auth_module/login/screens/otp_screen.dart';
import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/auth_module/signup/screen/quick_signup_screen.dart';
import 'package:Coretext/module/auth_module/signup/screen/register_screen.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/constants/StringConstants/string_constants.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
// import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatefulWidget {
  String? email;
  LoginScreen({
    super.key,
    this.email,
  });
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginViewModel loginDataViewModel = Get.put(LoginViewModel());
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    loginDataViewModel.loginMobileNumberController.text = "";
    loginDataViewModel.passwordController.text = "";
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return InternetAwareWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // First section (Blue with centered user icon)
                Container(
                  height: constraints.maxHeight *
                      0.36, // Upper 40% for blue section
                  width: constraints.maxWidth,
                  color: primaryColor, // Set blue color
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.height > 800
                              ? 120
                              : MediaQuery.of(context).size.height > 700
                                  ? 120
                                  : MediaQuery.of(context).size.height > 650
                                      ? 100
                                      : MediaQuery.of(context).size.height > 500
                                          ? 100
                                          : 90,
                          height: MediaQuery.of(context).size.height > 800
                              ? 120
                              : MediaQuery.of(context).size.height > 700
                                  ? 120
                                  : MediaQuery.of(context).size.height > 650
                                      ? 100
                                      : MediaQuery.of(context).size.height > 500
                                          ? 100
                                          : 90,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Profile-02.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height > 800
                              ? 20
                              : MediaQuery.of(context).size.height > 700
                                  ? 20
                                  : MediaQuery.of(context).size.height > 650
                                      ? 18
                                      : MediaQuery.of(context).size.height > 500
                                          ? 20
                                          : 16,
                        ),
                        const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Second section (White with email and submit button)
                Expanded(
                  child: Container(
                    width: constraints.maxWidth,
                    color: Colors.white, // Set white background
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Space at the top of the white container

                          spaceWidget(
                            height: MediaQuery.of(context).size.height > 800
                                ? 50
                                : MediaQuery.of(context).size.height > 700
                                    ? 50
                                    : MediaQuery.of(context).size.height > 650
                                        ? 40
                                        : MediaQuery.of(context).size.height >
                                                500
                                            ? 30
                                            : 20,
                          ), // Space between title and form
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Expanded(
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      controller:
                                          loginDataViewModel.emailController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: _validateEmail,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        errorStyle:
                                            const TextStyle(color: Colors.red),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            'assets/images/email_3747019.png', // Path to your image
                                            height:
                                                12.0, // Adjust the height as needed
                                            width:
                                                12.0, // Adjust the width as needed
                                          ),
                                        ),
                                        labelStyle: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black),
                                        errorMaxLines: 1,
                                        //  labelText: 'Enter Email Id *',
                                        hintText: 'Enter Email ID',
                                        hintStyle: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 16
                                                : MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        400
                                                    ? 14
                                                    : 12,
                                            color: Colors.black),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 20.0),
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors
                                                  .black), // Default underline color
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 1.0), // Focused underline
                                        ),
                                        errorBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 2.0), // Error underline
                                        ),
                                        focusedErrorBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red,
                                              width:
                                                  2.0), // Error underline on focus
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                spaceWidget(height: 30),
                                ElevatedButton(
                                  onPressed: _isButtonDisabled
                                      ? null // Disable the button if snackbar is showing
                                      : () async {
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            // Disable button to prevent multiple clicks
                                            setState(() {
                                              _isButtonDisabled = true;
                                            });

                                            // If the form is valid, proceed with the login
                                            showLoadingDialog();

                                            loginDataViewModel
                                                .login(
                                              email: loginDataViewModel
                                                  .emailController.text,
                                            )
                                                ?.then((loginModel) {
                                              hideLoadingDialog();

                                              if (loginModel?.status == true) {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      OtpScreen(
                                                    email: loginDataViewModel
                                                        .emailController.text,
                                                    loginFlag: 1,
                                                  ),
                                                ));
                                              } else if (loginModel?.message ==
                                                  "Unable to login, user in pending state or email not verified") {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      OtpScreen(
                                                    loginFlag: 0,
                                                    email: loginDataViewModel
                                                        .emailController.text,
                                                  ),
                                                ));
                                              } else {
                                                // Show snackbar and listen for its dismissal
                                                Get.snackbar(
                                                  'Error',
                                                  loginModel?.message ??
                                                      "Something went wrong",
                                                  backgroundColor: Colors.black,
                                                  colorText: Colors.white,
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  duration:
                                                      Duration(seconds: 3),
                                                );

                                                // Re-enable the button after the snackbar disappears
                                                Future.delayed(
                                                    Duration(seconds: 3), () {
                                                  setState(() {
                                                    _isButtonDisabled = false;
                                                  });
                                                });
                                              }
                                            });
                                          }
                                        },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.deepOrange),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        vertical: 10),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                spaceWidget(height: 30.0),
                                Center(
                                    child: GestureDetector(
                                  onTap: () async {
                                    showLoadingDialog();
                                    User? signInResult =
                                        await LoginViewModel.signInWithGoogle(
                                            context: context);
                                    hideLoadingDialog();
                                    List<String> nameParts = signInResult!
                                        .displayName!
                                        .trim()
                                        .split(' ');

                                    // Assign first name and last name to the respective controllers
                                    if (nameParts.isNotEmpty) {
                                      loginDataViewModel.firstNameController
                                          .text = nameParts[0]; // First name

                                      // If there's more than one name part, assign the last part as last name
                                      if (nameParts.length > 1) {
                                        loginDataViewModel
                                                .lastNameController.text =
                                            nameParts
                                                .sublist(1)
                                                .join(' '); // Last name
                                      }
                                    }

                                    //hideLoadingDialog();
                                    print(
                                        "SIGNIN RESULT ${signInResult!.uid ?? ""}");
                                    if (signInResult.emailVerified == true) {
                                      showLoadingDialog();
                                      APIBaseModel<LoginDataModel?>?
                                          loginModel =
                                          await loginDataViewModel.login(
                                              email: signInResult.email ?? "",
                                              gID: signInResult.uid ?? "");
                                      hideLoadingDialog();
                                      if (loginModel?.status == true) {
                                        loginDataViewModel
                                            .storeLoginResponseInSharedPreferences(
                                                isLogin: true);
                                        return Get.offAll(ArticleScreen(
                                          articleHeading: "",
                                        ));
                                      } else {
                                        if (loginModel?.message ==
                                            "Unable to login, user in pending state or email not verified") {
                                          loginDataViewModel
                                              .storeLoginResponseInSharedPreferences(
                                                  isLogin: true);

                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) => Register(
                                                userId: loginModel?.responseBody
                                                        ?.userId ??
                                                    0,
                                                emailId:
                                                    signInResult.email ?? "",
                                                isGoogleSignIn: true,
                                                gID: signInResult.uid,
                                                firstName: loginDataViewModel
                                                    .firstNameController.text,
                                                lastName: loginDataViewModel
                                                    .lastNameController.text,
                                              ),
                                            ),
                                          )
                                              .then((_) {
                                            // Show Snackbar after navigation
                                            Get.snackbar(
                                              '',
                                              loginModel?.message ??
                                                  "Unable to login, user in pending state or email not verified.",
                                              backgroundColor: Colors.black,
                                              colorText: Colors.white,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              duration: const Duration(
                                                  milliseconds: 5000),
                                            );
                                          });
                                          loginDataViewModel
                                              .storeLoginResponseInSharedPreferences(
                                                  isLogin: true);
                                        } else {
                                          Get.snackbar(
                                            backgroundColor: Colors.black,
                                            colorText: Colors.white,
                                            '',
                                            loginModel?.message ==
                                                    "Something went wrong"
                                                ? "Unable to found user! SIGNUP please."
                                                : loginModel?.message ??
                                                    "Unable to found user! SIGNUP please.",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          print("");
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => //BottomNavigationBarWidget(bodyWidget:
                                                          QuickSignupScreen(
                                                            emailId: signInResult
                                                                    .email ??
                                                                "",
                                                            isGoogleSignIn:
                                                                true,
                                                            gID: signInResult
                                                                .uid,
                                                            firstName:
                                                                loginDataViewModel
                                                                    .firstNameController
                                                                    .text,
                                                            lastName:
                                                                loginDataViewModel
                                                                    .lastNameController
                                                                    .text,
                                                          )
                                                  // )
                                                  ));
                                        }
                                      }
                                      // if (signInResult!.uid.isNotEmpty) {
                                      //   Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //           builder:
                                      //               (context) => //BottomNavigationBarWidget(bodyWidget:
                                      //                   Register(
                                      //                     emailId:
                                      //                         signInResult
                                      //                                 .email ??
                                      //                             "",
                                      //                     firstName:
                                      //                         signInResult
                                      //                             .displayName,
                                      //                     userId: 0,
                                      //                   )
                                      //           // )
                                      //           ));
                                    } else {
                                      Get.snackbar(
                                        backgroundColor: Colors.black,
                                        colorText: Colors.white,
                                        '',
                                        "Sign-in failed",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                      return Get.offAll(LoginScreen());
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          width: 30.0,
                                          height: 30.0,
                                          "assets/google.png"),
                                      const Text(
                                        "Sign in with Google",
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Create a new user"),
                    spaceWidget(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => QuickSignupScreen(
                            emailId: "",
                            isGoogleSignIn: false,
                          ),
                        ));
                      },
                      child: Text(
                        "SIGNUP",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            decorationColor: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
                spaceWidget(height: 10.0)
              ],
            );
          },
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter a valid email address';
  }
  final emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegExp.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}
