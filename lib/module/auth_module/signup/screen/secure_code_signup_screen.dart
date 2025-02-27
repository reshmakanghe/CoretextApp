import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:pinput/pinput.dart';

import '../../../../utils/WebService/api_base_model.dart';

// ignore: must_be_immutable
class SecureCodeSignUp extends StatefulWidget {
  String? mobileNumberController;
  SecureCodeSignUp({super.key, this.mobileNumberController});

  @override
  State<SecureCodeSignUp> createState() => _SecureCodeSignUpState();
}

class _SecureCodeSignUpState extends State<SecureCodeSignUp> {
  // SignupViewModel signupViewModel = Get.put(SignupViewModel());
  LoginViewModel loginViewModel = Get.put(LoginViewModel());
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  static const focusedBorderColor = Colors.cyanAccent;
  static const fillColor = Color.fromRGBO(243, 246, 249, 0);

  bool isContainerVisible = false;

  final defaultPinTheme = PinTheme(
    width: 65,
    height: 55,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(255, 255, 255, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      // border: Border.all(color: borderColor),
      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
    ),
  );
  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Page02/login_page_bg.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Secure Code',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      spaceWidget(height: 15.0),
                      Visibility(
                          child: Directionality(
                        // Specify direction if desired
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          controller: loginViewModel.passwordController,
                          focusNode: focusNode,
                          // androidSmsAutofillMethod:
                          //     AndroidSmsAutofillMethod.smsUserConsentApi,
                          // listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          separatorBuilder: (index) =>
                              const SizedBox(width: 19),
                          validator: (value) {
                            return value ==
                                    loginViewModel.passwordController.text
                                ? null
                                : 'Please enter valid secure code';
                          },
                          // onClipboardFound: (value) {
                          //   debugPrint('onClipboardFound: $value');
                          //   pinController.setText(value);
                          // },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: focusedBorderColor,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
                      )),
                      spaceWidget(height: 10.0),
                      const Text(
                        "Secure code has been sent to your registered email id.",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 10.0,
                // ),

                const SizedBox(
                  height: 40.0,
                ),

                // GestureDetector(
                //     onTap: () async {
                //       APIBaseModel<LoginDataModel?>? loginModel =
                //           await loginViewModel.verifyOTPWithMobileNumber(mobileNumberController : widget.mobileNumberController);
                //       await loginViewModel
                //           .storeLoginResponseInSharedPreferences();

                //       if (loginModel?.status == true) {
                //         Navigator.of(context).push(
                //           MaterialPageRoute(
                //             builder: (context) =>
                //                  BottomNavigationBarWidget(
                //               bodyWidget: LoginScreen(),
                //             ),
                //           ),
                //         );
                //       } else {
                //          Fluttertoast.showToast(
                //                             msg:
                //                                 loginModel?.message ??
                //                   "Something went wrong",
                //                             toastLength: Toast
                //                                 .LENGTH_LONG, // Duration for which the toast is visible
                //                             gravity: ToastGravity
                //                                 .BOTTOM, // Position of the toast message
                //                             backgroundColor: Colors
                //                                 .black87, // Background color of the toast
                //                             textColor: Colors
                //                                 .white, // Text color of the toast
                //                             fontSize:
                //                                 14.0, // Font size of the toast message
                //                           );
                //         // ScaffoldMessenger.of(context).showSnackBar(
                //         //   SnackBar(
                //         //     content: ConstantText(
                //         //       text: loginModel?.message ??
                //         //           "Something went wrong",
                //         //     ),
                //         //   ),
                //         // );
                //       }
                //       //await signupViewModel.storeLoginResponseInSharedPreferences();
                //     },

                //        ),
              ],
            ),
          ),
        ),
      ]),
      //     bottomNavigationBar: Padding(
      //     padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         GestureDetector(
      //           onTap: () async {
      //             // APIBaseModel<Map<String, dynamic>?>? responseData =
      //             //     await loginViewModel.getOTPForEnteredMobileNumber();
      //             // showBottomSheetDialog(responseData);
      //           },
      //           child: Container(
      //             padding: const EdgeInsets.symmetric(
      //                 vertical: 10.0, horizontal: 10.0),
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(10.0),
      //               color: const Color.fromRGBO(56,11,78,1.0)
      //             ),
      //             child: const Center(
      //               child: ConstantText(
      //                 text: signUp,
      //                 color: Colors.white,
      //                 fontSize: 14.0,
      //               ),
      //             ),
      //           ),
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             // (widget.isOnboard ?? false)
      //             const ConstantText(text: alreadyHaveAnAccount),
      //             //     : const ConstantText(text: newUserForSignup),
      //             spaceWidget(height: 30.0),
      //             InkWell(
      //               onTap: () {
      //                 pinController.text = '';
      //                 // loginViewModel.mobileNumberController.text = "";
      //                 // loginViewModel.sfaCodeController.text = "";
      //                 // loginViewModel.otpController.text = "";
      //                 // (widget.isOnboard ?? false)
      //                     Navigator.of(context).push(MaterialPageRoute(
      //                         builder: (context) =>
      //                             const LoginScreen()));
      //                 //     : Navigator.of(context).push(MaterialPageRoute(
      //                 //         builder: (context) =>
      //                 //             const LoginScreen(isOnboard: true)));
      //               },
      //               // child: (widget.isOnboard ?? false)
      //               //     ? const ConstantText(
      //               //         text: "Login",
      //               //         color: Color.fromARGB(255, 53, 23, 114),
      //               //       ):
      //                   child: const ConstantText(
      //                       text: "Login",
      //                       color: Color.fromARGB(255, 53, 23, 114),
      //                     ),
      //             )
      //           ],
      //         ),])

      // )
    );
  }
}
