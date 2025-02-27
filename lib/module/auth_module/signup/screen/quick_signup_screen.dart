import 'dart:async';

import 'package:Coretext/module/auth_module/login/model/login_data_model.dart';
import 'package:Coretext/module/auth_module/login/screens/login_screen.dart';
import 'package:Coretext/module/auth_module/login/screens/otp_screen.dart';
import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/auth_module/signup/model/signup_data_model.dart';
import 'package:Coretext/module/auth_module/signup/screen/register_screen.dart';
import 'package:Coretext/module/auth_module/signup/view_model/signup_view_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/constants/StringConstants/string_constants.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';

import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class QuickSignupScreen extends StatefulWidget {
  String emailId;
  String? firstName;
  String? lastName;
  bool? isGoogleSignIn;
  String? gID;
  QuickSignupScreen(
      {super.key,
      required this.emailId,
      this.firstName,
      this.lastName,
      this.isGoogleSignIn,
      this.gID});

  @override
  State<QuickSignupScreen> createState() => _QuickSignupScreenState();
}

class _QuickSignupScreenState extends State<QuickSignupScreen> {
  LoginViewModel loginViewModel = Get.put(LoginViewModel());
  SignupViewModel signupViewModel = Get.put(SignupViewModel());

  String timezone = "";
  DateTime dateTime = DateTime.now();
  final RxInt _remainingTime = 120.obs; // 5 minutes timer
  Timer? _timer;
  final RxString mobile = "".obs;
  final RxString? email = "".obs;
  bool _timerStarted = false;

  void _validateForm() {
    loginViewModel.isFormValid.value =
        loginViewModel.formKey.currentState?.validate() ?? false;
  }

  final pinController = TextEditingController();
  LoginViewModel loginDataViewModel = Get.put(LoginViewModel());

  final _emailFocus = FocusNode();
  final _dobFocus = FocusNode();
  final _zipCodeFocus = FocusNode();
  bool isMobileOtpVerified = false;
  bool isEmailOtpVerified = false;

  String? signature;

  @override
  void initState() {
    super.initState();

    checkConnectivity();
    _listenOTP();
    loginDataViewModel.emailController =
        TextEditingController(text: widget.emailId);
    loginDataViewModel.firstNameController =
        TextEditingController(text: widget.firstName);
    loginDataViewModel.lastNameController =
        TextEditingController(text: widget.lastName);
  }

  //listen otp from sms
  void _listenOTP() async {
    await SmsAutoFill().listenForCode();
  }

  void _verifyOtp(String otp) {
    bool isValidOtp = otp.length == 4;
  }

  final focusNode = FocusNode();

  // static const borderColor = Colors.cyanAccent;
  bool isContainerVisible = false;
  bool isSubmitted = false;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _emailFocus.dispose();
    _dobFocus.dispose();
    _zipCodeFocus.dispose();
    // loginDataViewModel.emailController.dispose();
    // cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InternetAwareWidget(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: primaryColor,
            resizeToAvoidBottomInset: false,
            body: LayoutBuilder(builder: (context, constraints) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context)
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
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/Profile-02.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 14
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 14
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 12
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 0
                                                            :0)
,                           Text(
                            "Quick Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context)
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
                          ),
                        ],
                      ),
                    ),
                    spaceWidget(height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 40
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 39
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 28
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 15
                                                            :14,),
                    Expanded(
                        child: Form(
                            key: loginViewModel.formKey,
                            // key: _formKey,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    left: 80.0,
                                    right: 80.0),
                                //  padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          cursorColor: Colors.white,
                                          keyboardType: TextInputType.text,

                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction, // Auto-validate on user interaction
                                          controller: loginViewModel
                                              .firstNameController,
                                          validator: _validateName,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            errorStyle: const TextStyle(
                                              color: Colors.red,
                                            ),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Image.asset(
                                                'assets/images/photo_16611670.png', // Path to your image
                                                height:
                                                    12.0, // Adjust the height as needed
                                                width:
                                                    12.0, // Adjust the width as needed
                                              ),
                                            ),
                                            errorMaxLines: 1,
                                            hintText: 'Enter First Name ',
                                            hintStyle: TextStyle(
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
                                                fontStyle: FontStyle.normal,
                                                color: Colors.white),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0),
                                            border: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .white), // Default underline color
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width:
                                                      2.0), // Focused underline
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width:
                                                      2.0), // Error underline
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
                                        spaceWidget(height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 40
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 39
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 28
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 15
                                                            :14,),
                                        TextFormField(
                                          cursorColor: Colors.white,
                                          keyboardType: TextInputType.text,

                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction, // Auto-validate on user interaction
                                          controller:
                                              loginViewModel.lastNameController,
                                          validator: _validateName,

                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            errorStyle: const TextStyle(
                                              color: Colors.red,
                                            ),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Image.asset(
                                                'assets/images/photo_16611670.png', // Path to your image
                                                height:
                                                    12.0, // Adjust the height as needed
                                                width:
                                                    12.0, // Adjust the width as needed
                                              ),
                                            ),
                                            labelStyle: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white),
                                            errorMaxLines: 1,
                                            hintText: 'Enter Last Name ',
                                            hintStyle: TextStyle(
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
                                                fontStyle: FontStyle.normal,
                                                color: Colors.white),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0),
                                            border: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .white), // Default underline color
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width:
                                                      2.0), // Focused underline
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width:
                                                      2.0), // Error underline
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
                                        spaceWidget(height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 40
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 39
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 28
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 15
                                                            :14,),
                                        TextFormField(
                                          readOnly:
                                              widget.isGoogleSignIn == true
                                                  ? true
                                                  : false,
                                          cursorColor: Colors.white,
                                          controller: loginDataViewModel
                                              .emailController,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: _validateEmail,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            errorStyle: const TextStyle(
                                                color: Colors.red),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
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
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
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
                                                color: Colors.white),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0),
                                            border: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .white), // Default underline color
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width:
                                                      2.0), // Focused underline
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width:
                                                      2.0), // Error underline
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
                                        spaceWidget(height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 50
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 49
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 28
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 15
                                                            :14,),
                                        Center(
                                          child: AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  3.0,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  // Navigator.of(context).push(
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) {
                                                  //   return OtpScreen();
                                                  // }));
                                                  _validateForm();
                                                  if (loginViewModel
                                                      .isFormValid.value) {
                                                    //  signupViewModel.submit();
                                                    loginDataViewModel
                                                        .toggleVisibility;
                                                    String appSignature =
                                                        await SmsAutoFill()
                                                            .getAppSignature;
                                                    if (widget.isGoogleSignIn ==
                                                        false) {
                                                      showLoadingDialog();
                                                      APIBaseModel<
                                                              LoginDataModel?>?
                                                          signupResponse =
                                                          await loginDataViewModel.sendOtp(
                                                              emailId:
                                                                  loginViewModel
                                                                      .emailController
                                                                      .text);
                                                      hideLoadingDialog();
                                                      print(signupResponse
                                                          ?.message);
                                                      // if (signupResponse
                                                      //         ?.status ==
                                                      //     true) {
                                                      if (signupResponse
                                                                      ?.message ==
                                                                  "User already exists" ||
                                                              signupResponse
                                                                      ?.message ==
                                                                  "Email already exists"
                                                          // "email already verify please sign_up"
                                                          ) {
                                                        Get.snackbar(
                                                            'Error',
                                                            signupResponse
                                                                    ?.message ??
                                                                "Something went wrong",
                                                            snackPosition:
                                                                SnackPosition
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.7),
                                                            duration: Duration(
                                                                seconds: 2),
                                                            colorText:
                                                                Colors.white);
                                                        // }
                                                        // Navigator.of(context).push(
                                                        //     MaterialPageRoute(
                                                        //         builder:
                                                        //             (context) =>
                                                        //                 LoginScreen(
                                                        //                   email: loginViewModel
                                                        //                       .emailController
                                                        //                       .text,
                                                        //                 )));
                                                        // Navigator.of(context).push(
                                                        //     MaterialPageRoute(
                                                        //         builder:
                                                        //             (context) =>
                                                        //                 Register(
                                                        //                   userId:
                                                        //                       signupResponse?.responseBody?.userId ?? 0,
                                                        //                   emailId: loginViewModel
                                                        //                       .emailController
                                                        //                       .text,
                                                        //                   firstName: loginViewModel
                                                        //                       .firstNameController
                                                        //                       .text,
                                                        //                   lastName: loginViewModel
                                                        //                       .lastNameController
                                                        //                       .text,
                                                        //                 )));
                                                      } else {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OtpScreen(
                                                                          loginFlag:
                                                                              0,
                                                                          email: loginViewModel
                                                                              .emailController
                                                                              .text,
                                                                          firstName: loginViewModel
                                                                              .firstNameController
                                                                              .text,
                                                                          lastName: loginViewModel
                                                                              .lastNameController
                                                                              .text,
                                                                        )));
                                                      }
                                                      // } else {
                                                      //   Get.snackbar(
                                                      //       'Error',
                                                      //       signupResponse
                                                      //               ?.message ??
                                                      //           "Something went wrong",
                                                      //       snackPosition:
                                                      //           SnackPosition
                                                      //               .BOTTOM,
                                                      //       backgroundColor:
                                                      //           Colors.black
                                                      //               .withOpacity(
                                                      //                   0.7),
                                                      //       duration: Duration(
                                                      //           seconds: 2),
                                                      //       colorText:
                                                      //           Colors.white);
                                                      // }
                                                    } else {
                                                      showLoadingDialog();
                                                      User? signInResult =
                                                          await LoginViewModel
                                                              .signInWithGoogle(
                                                                  context:
                                                                      context);
                                                      hideLoadingDialog();
                                                      List<String> nameParts =
                                                          signInResult!
                                                              .displayName!
                                                              .trim()
                                                              .split(' ');

                                                      // Assign first name and last name to the respective controllers
                                                      if (nameParts
                                                          .isNotEmpty) {
                                                        loginViewModel
                                                                .firstNameController
                                                                .text =
                                                            nameParts[
                                                                0]; // First name

                                                        // If there's more than one name part, assign the last part as last name
                                                        if (nameParts.length >
                                                            1) {
                                                          loginViewModel
                                                                  .lastNameController
                                                                  .text =
                                                              nameParts
                                                                  .sublist(1)
                                                                  .join(
                                                                      ' '); // Last name
                                                        }
                                                      }

                                                      //hideLoadingDialog();
                                                      print(
                                                          "SIGNIN RESULT ${signInResult!.uid ?? ""}");
                                                      if (signInResult
                                                              .emailVerified ==
                                                          true) {
                                                        showLoadingDialog();
                                                        APIBaseModel<
                                                                LoginDataModel?>?
                                                            loginModel =
                                                            await loginDataViewModel
                                                                .sendOtp(
                                                                    emailId:
                                                                        widget.emailId ??
                                                                            "",
                                                                    googleId:
                                                                        widget.gID ??
                                                                            "");
                                                        hideLoadingDialog();
                                                        print(loginModel
                                                            ?.message);
                                                        if (loginModel
                                                                ?.status ==
                                                            true) {
                                                          return Get.offAll(
                                                              Register(
                                                            userId: loginModel
                                                                    ?.responseBody
                                                                    ?.userId ??
                                                                0,
                                                            firstName:
                                                                loginViewModel
                                                                    .firstNameController
                                                                    .text,
                                                            lastName: loginViewModel
                                                                .lastNameController
                                                                .text,
                                                            gID: widget.gID ??
                                                                "",
                                                            isGoogleSignIn:
                                                                true,
                                                            emailId: widget
                                                                    .emailId ??
                                                                "",
                                                          ));
                                                        } else {
                                                          Get.snackbar(
                                                            backgroundColor:
                                                                Colors.black,
                                                            colorText:
                                                                Colors.white,
                                                            '',
                                                            loginModel
                                                                    ?.message ??
                                                                "Something went wrong",
                                                            snackPosition:
                                                                SnackPosition
                                                                    .BOTTOM,
                                                          );
                                                        }
                                                      } else {
                                                        Get.snackbar(
                                                          backgroundColor:
                                                              Colors.black,
                                                          colorText:
                                                              Colors.white,
                                                          '',
                                                          "Sign-in failed",
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                        );
                                                        return Get.offAll(
                                                            QuickSignupScreen(
                                                          gID:
                                                              signInResult!.uid,
                                                          isGoogleSignIn:
                                                              (signInResult.uid)
                                                                      .isNotEmpty
                                                                  ? true
                                                                  : false,
                                                          emailId: signInResult
                                                                  .email ??
                                                              "",
                                                        ));
                                                      }
                                                    }
                                                  } else {
                                                    Get.snackbar(
                                                        'Error',
                                                        // responseData?.message ??
                                                        "Plese fill all details",
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        backgroundColor: Colors
                                                            .black
                                                            .withOpacity(0.7),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        colorText:
                                                            Colors.white);
                                                  }
                                                },
                                                child: const Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ButtonStyle(
                                                  splashFactory:
                                                      InkRipple.splashFactory,
                                                  overlayColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                    (states) {
                                                      return states.contains(
                                                              MaterialState
                                                                  .pressed)
                                                          ? Colors.grey
                                                          : null;
                                                    },
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    loginDataViewModel
                                                            .isGoogleVisible
                                                            .value
                                                        ? Color(0xffeb602f)
                                                        : Color(0xffeb602f),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0), // Set to 0 for square shape
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        spaceWidget(height: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 30
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 29
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 28
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 10
                                                            :8,),
                                        Center(
                                            child: GestureDetector(
                                          onTap: () async {
                                            showLoadingDialog();
                                            User? signInResult =
                                                await LoginViewModel
                                                    .signInWithGoogle(
                                                        context: context);
                                            hideLoadingDialog();
                                            List<String> nameParts =
                                                signInResult!.displayName!
                                                    .trim()
                                                    .split(' ');

                                            // Assign first name and last name to the respective controllers
                                            if (nameParts.isNotEmpty) {
                                              loginViewModel.firstNameController
                                                      .text =
                                                  nameParts[0]; // First name

                                              // If there's more than one name part, assign the last part as last name
                                              if (nameParts.length > 1) {
                                                loginViewModel
                                                        .lastNameController
                                                        .text =
                                                    nameParts
                                                        .sublist(1)
                                                        .join(' '); // Last name
                                              }
                                            }

                                            //hideLoadingDialog();
                                            print(
                                                "SIGNIN RESULT ${signInResult!.uid ?? ""}");
                                            if (signInResult.emailVerified ==
                                                true) {
                                              showLoadingDialog();
                                              APIBaseModel<LoginDataModel?>?
                                                  loginModel =
                                                  await loginDataViewModel
                                                      .sendOtp(
                                                          emailId: signInResult
                                                                  .email ??
                                                              "",
                                                          googleId: signInResult
                                                                  ?.uid ??
                                                              "");
                                              hideLoadingDialog();
                                              print(loginModel?.message);
                                              if (loginModel?.status == true) {
                                                loginViewModel
                                                    .storeLoginResponseInSharedPreferences(
                                                        isLogin: true);
                                                return Get.offAll(Register(
                                                  userId: loginModel
                                                          ?.responseBody
                                                          ?.userId ??
                                                      0,
                                                  firstName: loginViewModel
                                                      .firstNameController.text,
                                                  lastName: loginViewModel
                                                      .lastNameController.text,
                                                  gID: signInResult?.uid ?? "",
                                                  isGoogleSignIn: true,
                                                  emailId:
                                                      signInResult?.email ?? "",
                                                ));
                                              } else {
                                                Get.snackbar(
                                                  backgroundColor: Colors.black,
                                                  colorText: Colors.white,
                                                  '',
                                                  loginModel?.message ??
                                                      "Something went wrong",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                );
                                              }
                                            } else {
                                              Get.snackbar(
                                                backgroundColor: Colors.black,
                                                colorText: Colors.white,
                                                '',
                                                "Sign-in failed",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                              return Get.offAll(
                                                  QuickSignupScreen(
                                                gID: signInResult!.uid,
                                                isGoogleSignIn:
                                                    (signInResult.uid)
                                                            .isNotEmpty
                                                        ? true
                                                        : false,
                                                emailId:
                                                    signInResult.email ?? "",
                                              ));
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  width: 30.0,
                                                  height: 30.0,
                                                  "assets/google.png"),
                                              const Text(
                                                "Sign in with Google",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        )),
                                        Padding(
                                          padding:  EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    800
                                                ? 100
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        700
                                                    ? 48
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .height >
                                                            650
                                                        ? 46
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .height >
                                                                500
                                                            ? 18
                                                            :18,),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "User already exist! ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              spaceWidget(width: 5.0),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen(
                                                      email: loginDataViewModel
                                                          .emailController.text,
                                                      // isGoogleSignIn: false,
                                                    ),
                                                  ));
                                                },
                                                child: const Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.deepOrange,
                                                      decorationColor:
                                                          Colors.deepOrange),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ))))
                  ]);
            })));
  }

  String? _validateMobileNumber(String? value) {
    //RegExp regex = RegExp(r'^[789]\d{8,9}$');
    RegExp regex = RegExp(r'^\d{10}$');

    if (value == null || value.isEmpty) {
      return '';
    } else if (value.length < 1) {
      return null; // Don't show any error message until 1 digit is entered
    } else if (!regex.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? _validateED(String? value) {
    RegExp regex = RegExp(r'^[789]\d{8,9}$');

    if (value == null || value.isEmpty) {
      return '';
    }

    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegExp.hasMatch(value)) {
      return 'First name should contain only alphabets';
    }
    return null;
  }

// Validation logic for the email field
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateZipCode(String? value) {
    RegExp regex =
        RegExp(r'^\d{6}$'); // Regular expression to match exactly 6 digits

    if (value == null || value.isEmpty) {
      return 'Zip code cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Zip code must be exactly 6 digits';
    }

    return null; // Return null if the validation is successful
  }

  void _startTimerOnce() {
    if (!_timerStarted) {
      _timerStarted = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime.value > 0) {
          _remainingTime.value--;
        } else {
          _timer?.cancel();
          // Clear OTP field when the timer ends
          loginDataViewModel.passwordController.clear();
        }
      });
    }
  }

  void _resetAndStartTimer() {
    mobile.value = loginDataViewModel.mobileNumberController.text;
    email?.value = loginDataViewModel.emailController.text;
    _timer?.cancel(); // Cancel the existing timer
    _remainingTime.value = 120; // Reset the timer to 5 minutes
    loginDataViewModel.passwordController.clear(); // Clear the OTP field
    _timerStarted = false;
    _startTimerOnce(); // Start the timer again
  }
}
