import 'dart:async';

import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/module/auth_module/login/model/login_data_model.dart';
import 'package:Coretext/module/auth_module/login/screens/login_screen.dart';
import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/auth_module/signup/model/verify_otp_data_model.dart';
import 'package:Coretext/module/auth_module/signup/screen/register_screen.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../utils/widgetConstant/common_widget/common_widget.dart';

//import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  final String? email;
  final String? firstName;
  final String? lastName;
  final int loginFlag;
  const OtpScreen(
      {super.key,
      this.email,
      this.firstName,
      this.lastName,
      required this.loginFlag});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final LoginViewModel loginDataViewModel = Get.put(LoginViewModel());
  Timer? _timer;
  bool _timerStarted = false;
  bool isMobileOtpVerified = false;
  final RxInt _remainingTime = 120.obs;

  @override
  void initState() {
    super.initState();
    _startTimerOnce();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimerOnce() {
    if (!_timerStarted) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!mounted) return; // Check if the widget is still mounted
        if (_remainingTime.value > 0) {
          setState(() {
            _remainingTime.value--;
          });
        } else {
          _timer?.cancel();
          loginDataViewModel.passwordController.clear();
        }
      });
      _timerStarted = true;
    }
  }

  Future<bool> _onWillPop() async {
    // Navigate to the login screen when back button is pressed
    Get.offAll(LoginScreen());
    return Future.value(
        false); // Prevent default behavior of popping the screen
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height:
                      constraints.maxHeight * 0.4, // Upper 40% for blue section
                  width: constraints.maxWidth,
                  color: primaryColor, // Set blue color
                  child: Center(
                    child: SingleChildScrollView(
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
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Visibility(
                    visible: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            "Enter OTP",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        spaceWidget(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 90.0),
                          child: PinFieldAutoFill(
                              keyboardType: TextInputType.number,
                              currentCode:
                                  loginDataViewModel.passwordController.text,
                              codeLength: 4,
                              controller: loginDataViewModel.passwordController,
                              onCodeChanged: (value) {
                                loginDataViewModel.passwordController.text =
                                    value!;
                              },
                              decoration: UnderlineDecoration(
                                obscureStyle: ObscureStyle(
                                    isTextObscure: true, obscureText: "*"),
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                colorBuilder: FixedColorBuilder(Colors.black),
                              )),
                        ),
                        // spaceWidget(height: 10.0),
                        // Obx(() => Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 90.0),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           Icon(Icons.timer,
                        //               size: 20.0,
                        //               color: Colors.black.withOpacity(0.5)),
                        //           SizedBox(width: 4),
                        //           Text(
                        //             "${(_remainingTime.value ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime.value % 60).toString().padLeft(2, '0')}",
                        //             style: const TextStyle(
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //         ],
                        //       ),
                        //     )),
                        spaceWidget(height: 30.0),
                        // Obx(() =>
                        ElevatedButton(
                          onPressed: () async {
                            // if (_remainingTime.value == 0) {
                            //   showLoadingDialog();
                            //   APIBaseModel? otpResponse =
                            //       await loginDataViewModel.sendOtp(
                            //           emailId: widget.email);
                            //   hideLoadingDialog();
                            //   if (otpResponse?.status == true) {
                            //     Get.snackbar(
                            //         'OTP',
                            //         otpResponse?.message ??
                            //             'Please enter a valid OTP',
                            //         backgroundColor: Colors.black,
                            //         colorText: Colors.white,
                            //         snackPosition: SnackPosition.BOTTOM);
                            //     _resetAndStartTimer();
                            //   }
                            // } else {
                            String otp =
                                loginDataViewModel.passwordController.text;
                            if (otp.isEmpty) {
                              Get.snackbar('Error', 'Please enter a valid OTP',
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            } else {
                              if (widget.loginFlag == 0) {
                                showLoadingDialog();
                                APIBaseModel<VerifyOtpDataModel?>? loginModel =
                                    await loginDataViewModel.verifyOTP(
                                        emailId: widget.email!);
                                hideLoadingDialog();
                                int userId =
                                    loginModel?.responseBody?.userId ?? 0;
                                print(userId);

                                if (loginModel?.message ==
                                    "Email verified successfully, please sign up") {
                                  loginDataViewModel
                                      .storeLoginResponseInSharedPreferences(
                                          isLogin: false);

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Register(
                                        emailId: widget.email ?? "",
                                        firstName: widget.firstName ?? "",
                                        lastName: widget.lastName ?? "",
                                        userId:
                                            loginModel?.responseBody?.userId ??
                                                0,
                                      ),
                                      //),
                                    ),
                                  );
                                } else {
                                  Get.snackbar(
                                      'Error',
                                      loginModel?.message ??
                                          "Something went wrong",
                                      backgroundColor: Colors.black,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              } else {
                                showLoadingDialog();
                                APIBaseModel<LoginDataModel?>? loginModel =
                                    await loginDataViewModel.login(
                                        email: loginDataViewModel
                                            .emailController.text);
                                hideLoadingDialog();
                                if (loginModel?.status == true) {
                                  loginDataViewModel
                                      .storeLoginResponseInSharedPreferences(
                                          isLogin: true);
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => ArticleScreen(
                                        articleHeading: "",
                                      ),
                                    ),
                                    (Route<dynamic> route) => false, // This condition removes all previous routes
                                  );
                                } else {
                                  if ((loginModel?.responseBody?.status ==
                                          "pending") ||
                                      (loginModel?.message ==
                                          "Unable to login, user in pending state or email not verified")) {
                                    loginDataViewModel
                                        .storeLoginResponseInSharedPreferences(
                                            isLogin: true);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Register(
                                          emailId: widget.email ?? "",
                                          firstName: widget.firstName ?? "",
                                          lastName: widget.lastName ?? "",
                                          userId: loginModel
                                                  ?.responseBody?.userId ??
                                              0,
                                        ),
                                        //),
                                      ),
                                    );
                                  } else {
                                    Get.snackbar(
                                        'Error',
                                        loginModel?.message ??
                                            "Something went wrong",
                                        backgroundColor: Colors.black,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                }
                              }
                            }
                            // }
                          },
                          style: ButtonStyle(
                            splashFactory: InkRipple.splashFactory,
                            backgroundColor:
                                MaterialStateProperty.all(Colors.deepOrange),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          child: Text(
                            // _remainingTime.value == 0
                            //     ? 'Resend OTP'
                            //     :
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.height >
                                        800
                                    ? 17
                                    : MediaQuery.of(context).size.height > 700
                                        ? 16
                                        : MediaQuery.of(context).size.height >
                                                650
                                            ? 15
                                            : MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    500
                                                ? 10
                                                : MediaQuery.of(context)
                                                            .size
                                                            .height >
                                                        400
                                                    ? 13
                                                    : 12),
                          ),
                        )
                        //)
                        ,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _resetAndStartTimer() {
    _timer?.cancel();
    _remainingTime.value = 120;
    loginDataViewModel.passwordController.clear();
    _timerStarted = false;
    _startTimerOnce();
  }
}
