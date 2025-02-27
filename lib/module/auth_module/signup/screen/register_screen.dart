import 'dart:async';
import 'dart:ffi';

import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/module/auth_module/login/model/login_data_model.dart';
import 'package:Coretext/module/auth_module/login/screens/login_screen.dart';
import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/module/auth_module/signup/model/signup_data_model.dart';
import 'package:Coretext/module/auth_module/signup/view_model/signup_view_model.dart';
import 'package:Coretext/module/speciality_page_module/speciality_module/view_model/speciality_view_model.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:Coretext/utils/constants/StringConstants/string_constants.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:Coretext/utils/internet_connectivity.dart';
import 'package:Coretext/utils/internet_connectivity/internet_connectivity.dart';
import 'package:Coretext/utils/loader.dart';
import 'package:Coretext/utils/widgetConstant/common_widget/common_widget.dart';
import 'package:Coretext/utils/widgetConstant/text_widget/text_constant_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import 'package:sms_autofill/sms_autofill.dart';

class Register extends StatefulWidget {
  String emailId;
  String firstName;

  String lastName;
  int? userId;
  bool? isGoogleSignIn;
  String? gID;
  Register(
      {super.key,
      required this.emailId,
      required this.firstName,
      this.userId,
      required this.lastName,
      this.isGoogleSignIn,
      this.gID});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  LoginViewModel loginViewModel = Get.put(LoginViewModel());
  SignupViewModel signupViewModel = Get.put(SignupViewModel());
  final _formKey = GlobalKey<FormState>();

  String timezone = "";
  DateTime dateTime = DateTime.now();

  final RxInt _remainingTime = 120.obs; // 5 minutes timer
  Timer? _timer;
  final RxString mobile = "".obs;
  final RxString? email = "".obs;

  bool _timerStarted = false;

  void _validateForm() {
    loginViewModel.isFormValidSignUp.value =
        loginViewModel.formKeySignUp.currentState?.validate() ?? false;
  }

  // TextEditingController emailIdController = TextEditingController();
  final pinController = TextEditingController();
  LoginViewModel loginDataViewModel = Get.put(LoginViewModel());
  SpecialityViewModel specialityViewModel = Get.put(SpecialityViewModel());

  final _emailFocus = FocusNode();
  final _dobFocus = FocusNode();
  final _zipCodeFocus = FocusNode();
  bool isMobileOtpVerified = false;
  bool isEmailOtpVerified = false;

  String? signature;

  // get time zone

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showLoadingDialog();
      await specialityViewModel.fetchSpecialties();
      // if (loginViewModel.isDoctor.value == "Yes") {

      //  }
      hideLoadingDialog();

      // Initialize the controller with widget.lastName if available
      loginViewModel.emailController.text = widget.emailId ?? "";

      // Add a listener to update the controller if the text changes
      loginViewModel.emailController.addListener(() {
        // Check if the new text differs from widget.lastName and update if necessary
        if (loginViewModel.emailController.text != widget.emailId) {
          // Update with new value
          widget.emailId = loginViewModel.emailController.text;
        }
      });
    });
    loginViewModel.firstNameController.text = widget.firstName ?? "";
    // Add a listener to update the controller if the text changes
    loginViewModel.firstNameController.addListener(() {
      // Check if the new text differs from widget.lastName and update if necessary
      if (loginViewModel.firstNameController.text != widget.firstName) {
        // Update with new value
        widget.firstName = loginViewModel.firstNameController.text;
      }
    });

    loginViewModel.lastNameController.text = widget.lastName ?? "";
    // Add a listener to update the controller if the text changes
    loginViewModel.lastNameController.addListener(() {
      // Check if the new text differs from widget.lastName and update if necessary
      if (loginViewModel.lastNameController.text != widget.lastName) {
        // Update with new value
        widget.lastName = loginViewModel.lastNameController.text;
      }
    });

    loginDataViewModel.loadRegistrationData();
    checkConnectivity();
    _listenOTP();
    // loginDataViewModel.emailController =
    //     TextEditingController(text: widget.emailId);
    // loginDataViewModel.firstNameController =
    //     TextEditingController(text: widget.firstName);
    // loginDataViewModel.lastNameController =
    //     TextEditingController(text: widget.lastName);
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
    loginDataViewModel.saveRegistrationData();
    // loginDataViewModel.emailController.dispose();
    loginViewModel.lastNameController.removeListener(() {});
    // cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Close the app gracefully using SystemNavigator.pop()
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
        return false; // Prevent further popping
      },
      child: InternetAwareWidget(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: constraints.maxHeight *
                        0.4, // Upper 40% for blue section
                    width: constraints.maxWidth,
                    color: primaryColor, // Set blue color
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   "assets/images/Profile-02.png",
                        //   width: 300.0,
                        // ),
                        Container(
                          width: 200,
                          height: 200,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Profile-02.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Text(
                          "Registration",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceWidget(height: 20.0),
                  spaceWidget(height: 10.0),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Form(
                        key: loginViewModel.formKeySignUp,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: 50.0,
                              right: 50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Add the image to the row
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 20.0),
                                    child: Image.asset(
                                      'assets/images/photo_16611670.png', // Your image path
                                      width:
                                          30.0, // Adjust the size of the image
                                      height: 30.0,
                                    ),
                                  ),
                                  // TextFormField with hint text centered
                                  Expanded(
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.text,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller:
                                          loginViewModel.firstNameController,
                                      validator: _validateName,
                                      onChanged: (value) {
                                        loginDataViewModel
                                            .saveRegistrationData(); // Save the data when the field changes
                                      },
                                      style:
                                          const TextStyle(color: Colors.black),
                                      textAlign: TextAlign
                                          .left, // Center the text (including hint)
                                      decoration: InputDecoration(
                                        errorStyle:
                                            const TextStyle(color: Colors.red),
                                        // prefixIcon: const Icon(
                                        //     Icons.text_format_rounded),
                                        errorMaxLines: 1,
                                        errorBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        // Error border when the field is focused
                                        focusedErrorBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        hintText: 'Enter First Name',
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
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.9),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // Add the image to the row
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 20.0),
                                    child: Image.asset(
                                      'assets/images/photo_16611670.png', // Your image path
                                      width:
                                          30.0, // Adjust the size of the image
                                      height: 30.0,
                                    ),
                                  ),
                                  // TextFormField with hint text centered
                                  Expanded(
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.text,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller:
                                          loginViewModel.lastNameController,
                                      validator: _validateName,
                                      onChanged: (value) {
                                        loginDataViewModel
                                            .saveRegistrationData(); // Save the data when the field changes
                                      },
                                      style:
                                          const TextStyle(color: Colors.black),
                                      textAlign: TextAlign
                                          .left, // Center the text and hint text
                                      decoration: InputDecoration(
                                        errorStyle:
                                            const TextStyle(color: Colors.red),
                                        // prefixIcon: const Icon(
                                        //     Icons.text_format_rounded),
                                        labelStyle: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        errorMaxLines: 1,
                                        errorBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        // Error border when the field is focused
                                        focusedErrorBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        hintText: 'Enter Last Name',
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
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.9),
                                        ),

                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 25.0, left: 4.0),
                                    child: Image.asset(
                                      'assets/images/email_3747019.png', // Your image path
                                      width:
                                          25.0, // Adjust the size of the image
                                      height: 25.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        readOnly: true,
                                        cursorColor: Colors.black,
                                        controller:
                                            loginDataViewModel.emailController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: _validateEmail,
                                        onChanged: (value) {
                                          loginDataViewModel
                                              .saveRegistrationData(); // Save the data when the field changes
                                        },
                                        // onChanged: (value) {
                                        //   // _validateForm();
                                        //   // setState(() {
                                        //   //   // Reset border color when user starts typing
                                        //   // });
                                        // },
                                        style: const TextStyle(
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: Colors.red),
                                          // prefixIcon:
                                          //     const Icon(Icons.email_outlined),
                                          labelStyle: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                          errorMaxLines: 1,
                                          errorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          // Error border when the field is focused
                                          focusedErrorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
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
                                              color: Colors.black
                                                  .withOpacity(0.9)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 20.0),
                                    child: Image.asset(
                                      'assets/images/smartphone_3694647.png', // Your image path
                                      width:
                                          30.0, // Adjust the size of the image
                                      height: 30.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        cursorColor: Colors.black,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(
                                                  r'[0-9]')), // Only allow digits
                                          LengthLimitingTextInputFormatter(
                                              10), // Limit input to 10 characters
                                        ],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textAlign: TextAlign
                                            .left, // Auto-validate on user interaction
                                        controller: loginViewModel
                                            .mobileNumberController,
                                        validator: _validateMobileNumber,
                                        // onChanged: (value) {
                                        //   _validateForm();
                                        //   setState(() {
                                        //     // Reset border color when user starts typing
                                        //   });
                                        // },
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                          // prefixIcon:
                                          //     const Icon(Icons.mobile_friendly),
                                          errorStyle: const TextStyle(
                                            color: Colors.red,
                                          ),
                                          labelStyle: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal,
                                              color: const Color.fromARGB(
                                                      255, 0, 0, 0)
                                                  .withOpacity(0.1)),
                                          errorMaxLines: 1,
                                          errorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          // Error border when the field is focused
                                          focusedErrorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          hintText: 'Enter Mobile Number ',
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
                                              color: const Color.fromARGB(
                                                      255, 0, 0, 0)
                                                  .withOpacity(0.9)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 23.0),
                                    child: Image.asset(
                                      'assets/images/gps_13953734.png', // Your image path
                                      width:
                                          25.0, // Adjust the size of the image
                                      height: 25.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Obx(() {
                                      // Access the observable list as a regular List<String>
                                      List<String> statesList =
                                          loginDataViewModel.states.toList();

                                      return DropdownButtonFormField<String>(
                                        menuMaxHeight: 290,
                                        isDense: true,
                                        isExpanded: true,
                                        items: statesList.map((state) {
                                          return DropdownMenuItem<String>(
                                            value: state,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14.0),
                                              child: Text(state,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 14.0),
                                          child: Text(
                                            'State',
                                            style: TextStyle(
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
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        value: loginViewModel
                                                .selectedState.value.isNotEmpty
                                            ? loginViewModel.selectedState.value
                                            : null,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a state';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value != null &&
                                              value.isNotEmpty) {
                                            loginViewModel.selectedState.value =
                                                value;

                                            // Revalidate the form to remove the error
                                            loginViewModel
                                                .formKeySignUp.currentState
                                                ?.validate();
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          errorStyle: TextStyle(
                                              color: Color(0xffeb602f)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.grey,
                                          )),
                                          errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                        ),
                                      );
                                    }),
                                  ),

                                  // Expanded(
                                  //   child: Obx(
                                  //     () => DropdownButtonFormField<String>(
                                  //       isExpanded: true,
                                  //       items: loginDataViewModel.states
                                  //           .map((state) {
                                  //         return DropdownMenuItem<String>(
                                  //           value: state,
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 14.0),
                                  //             child: Text(state,
                                  //                 style: TextStyle(
                                  //                     fontWeight:
                                  //                         FontWeight.normal)),
                                  //           ),
                                  //         );
                                  //       }).toList(),
                                  //       hint: Padding(
                                  //         padding: EdgeInsets.only(left: 14.0),
                                  //         child: Text(
                                  //           'State',
                                  //           style: TextStyle(
                                  //               fontStyle: FontStyle.normal,
                                  //               fontSize: MediaQuery.of(context)
                                  //                           .size
                                  //                           .width >
                                  //                       600
                                  //                   ? 16
                                  //                   : MediaQuery.of(context)
                                  //                               .size
                                  //                               .width >
                                  //                           400
                                  //                       ? 14
                                  //                       : 12,
                                  //               color: Colors.black),
                                  //         ),
                                  //       ),
                                  //       value:
                                  //           loginViewModel.selectedState.value,
                                  //       validator: (value) {
                                  //         if (value == null || value.isEmpty) {
                                  //           return ''; // Display an error message if no state is selected
                                  //         }
                                  //         return null; // Return null if validation passes
                                  //       },
                                  //       onChanged: (value) {
                                  //         if (value != null) {
                                  //           loginViewModel.selectedState.value =
                                  //               value;
                                  //           Form.of(context).validate();
                                  //         }
                                  //       },
                                  //       decoration: const InputDecoration(
                                  //         errorStyle: const TextStyle(
                                  //             color: Color(0xffeb602f)),
                                  //         errorBorder:
                                  //             const UnderlineInputBorder(
                                  //           borderSide: BorderSide(
                                  //               color: Colors.red, width: 2),
                                  //         ),
                                  //         // Error border when the field is focused
                                  //         focusedErrorBorder:
                                  //             const UnderlineInputBorder(
                                  //           borderSide: BorderSide(
                                  //               color: Colors.red, width: 2),
                                  //         ),

                                  //         contentPadding:
                                  //             const EdgeInsets.symmetric(
                                  //           vertical: 10.0,
                                  //           horizontal: 10.0,
                                  //         ),
                                  //         // prefixIcon:
                                  //         //     const Icon(Icons.person_add_alt),
                                  //         // Error border
                                  //         // focusedBorder: OutlineInputBorder(
                                  //         //   borderSide: BorderSide(
                                  //         //     color: loginViewModel.selectedState.value ==
                                  //         //                 null ||
                                  //         //             loginViewModel
                                  //         //                 .selectedState.value!.isEmpty
                                  //         //         ? Colors.red
                                  //         //         : Colors.grey.withOpacity(0.1),
                                  //         //   ),
                                  //         // ),
                                  //         // Default border
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 24.0),
                                    child: Image.asset(
                                      'assets/images/doctor_1979869.png', // Your image path
                                      width:
                                          25.0, // Adjust the size of the image
                                      height: 25.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Obx(
                                      () => DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        items:
                                            ["Yes", "No"].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14.0),
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Padding(
                                          padding: EdgeInsets.only(left: 14.0),
                                          child: Text(
                                            'Doctor', // Text shown before selecting an option
                                            style: TextStyle(
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
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        value: loginViewModel
                                                .isDoctor.value!.isEmpty
                                            ? null // Show hint when no value is selected
                                            : loginViewModel.isDoctor
                                                .value, // Set the selected value
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select Yes or No'; // Validation message
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          loginViewModel.isDoctor.value =
                                              value ?? '';
                                          loginViewModel
                                              .formKeySignUp.currentState
                                              ?.validate(); // Update doctor selection
                                        },
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 10.0,
                                          ),
                                          //prefixIcon: Icon(Icons.person),
                                          errorStyle: TextStyle(
                                              color: Color(0xffeb602f)),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.grey,
                                          )),
                                          errorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          // Error border when the field is focused
                                          focusedErrorBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () {
                                  return GestureDetector(
                                    onTap: () => _showSpecialityDialog(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                      ),
                                      decoration: UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        insets: EdgeInsets.only(
                                            left: 39.0,
                                            right: 0.0,
                                            bottom:
                                                4.0), // Adjust the position of the underline
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 3.0, top: 10.0),
                                            child: Image.asset(
                                              'assets/images/favorite_14866738.png', // Your image path
                                              width: 30.0,
                                              height: 30.0,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11.0,
                                                vertical: 1.0),
                                            // child: Icon(
                                            //     Icons.medical_information),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                loginViewModel
                                                        .selectedSpecialities
                                                        .isEmpty
                                                    ? "My Interest"
                                                    : loginViewModel
                                                        .selectedSpecialities
                                                        .map(
                                                          (id) =>
                                                              specialityViewModel
                                                                  .specialties
                                                                  .firstWhere(
                                                                    (speciality) =>
                                                                        speciality
                                                                            .catId ==
                                                                        id,
                                                                  )
                                                                  .catName,
                                                        )
                                                        .join(", "),
                                                textAlign: TextAlign
                                                    .left, // Display names instead of IDs
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    // fontStyle: FontStyle.normal,
                                                    fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width >
                                                            600
                                                        ? 16
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                400
                                                            ? 14
                                                            : 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  );
                                  // Spacing between Doctor and Specialty dropdown
                                },
                              ),
                              Obx(
                                () {
                                  return loginViewModel.isDoctor.value == "Yes"
                                      ? Row(
                                          children: [
                                            // Add the image to the row
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 20.0,
                                                right: 6.0,
                                              ),
                                              child: Image.asset(
                                                'assets/images/favorite_14866738.png', // Your iage path
                                                width:
                                                    30.0, // Adjust the size of the image
                                                height: 30.0,
                                              ),
                                            ),
                                            // TextFormField in Expanded to take remaining space
                                            Expanded(
                                              child: TextFormField(
                                                cursorColor: Colors.black,
                                                keyboardType:
                                                    TextInputType.text,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                controller: loginViewModel
                                                            .isDoctor.value ==
                                                        "Yes"
                                                    ? loginViewModel
                                                        .specialityController
                                                    : TextEditingController(
                                                        text: ""),
                                                validator: _validateName,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                textAlign: TextAlign.left,
                                                // Center the text and hint
                                                decoration: InputDecoration(
                                                  errorStyle: const TextStyle(
                                                      color: Color(0xffeb602f)),
                                                  // prefixIcon: const Icon(
                                                  //     Icons.medical_services),
                                                  labelStyle: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                  errorMaxLines: 1,

                                                  errorBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 2),
                                                  ),
                                                  // Error border when the field is focused
                                                  focusedErrorBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 2),
                                                  ),
                                                  hintText: 'Speciality',
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 30.0,
                                                  ),
                                                  hintStyle: TextStyle(
                                                    fontSize: MediaQuery.of(
                                                                    context)
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
                                                    color: const Color.fromARGB(
                                                            255, 0, 0, 0)
                                                        .withOpacity(0.9),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container();
                                },
                              ),
                              spaceWidget(height: 20.0),
                              Obx(() => Center(
                                    child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 500),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          _validateForm();

                                          if (loginViewModel
                                              .isFormValidSignUp.value) {
                                            showLoadingDialog();
                                            APIBaseModel<LoginDataModel?>?
                                                signupResponse =
                                                await loginDataViewModel.signUp(
                                                    userId: widget.userId ?? 0);
                                            hideLoadingDialog();
                                            //   print(
                                            //       "Sign response ==================>$signupResponse");
                                            //   print("GID  ${widget.gID}");
                                            //   // await signupViewModel
                                            //   //     .storeSignupResponseInSharedPreferences();
                                            //   final signResult = signupResponse
                                            //           ?.responseBody?.userId ??
                                            //       0;
                                            //   print("signResult $signResult");
                                            if (signupResponse?.status ==
                                                true) {
                                              loginDataViewModel
                                                  .storeLoginResponseInSharedPreferences(
                                                      isLogin: true);

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ArticleScreen(
                                                            articleHeading: "",
                                                          )));
                                            } else {
                                              Get.snackbar(
                                                  'Error',
                                                  signupResponse?.message ??
                                                      "Something went wrong",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.7),
                                                  duration:
                                                      Duration(seconds: 2),
                                                  colorText: Colors.white);
                                            }
                                          } else {
                                            Get.snackbar(
                                                'Error',
                                                // responseData?.message ??
                                                "Plese fill all details",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.7),
                                                duration: Duration(seconds: 2),
                                                colorText: Colors.white);
                                          }
                                        },
                                        child: const Text(
                                          'Save Profile',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: ButtonStyle(
                                          splashFactory:
                                              InkRipple.splashFactory,
                                          overlayColor:
                                              MaterialStateProperty.resolveWith(
                                            (states) {
                                              return states.contains(
                                                      MaterialState.pressed)
                                                  ? Colors.grey
                                                  : null;
                                            },
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            loginDataViewModel
                                                    .isGoogleVisible.value
                                                ? Colors.deepOrange
                                                : Colors.deepOrange,
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  30.0), // Set to 0 for square shape
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )),
                  ))
                ],
              );
            },
          ),
          extendBody: true,
        ),
      ),
    );
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

  void _showSpecialityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Interest"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: specialityViewModel.specialties.map((speciality) {
                return Obx(
                  () {
                    // Check if the selectedSpecialities contains the catId
                    bool isSelected = loginViewModel.selectedSpecialities
                        .contains(speciality.catId);
                    return CheckboxListTile(
                      title: Text(speciality.catName ?? ''), // Display the name
                      value: isSelected,
                      onChanged: (bool? selected) {
                        if (selected == true) {
                          // Add category ID to selectedSpecialities
                          loginViewModel.selectedSpecialities
                              .add(speciality.catId!);
                        } else {
                          // Remove category ID from selectedSpecialities
                          loginViewModel.selectedSpecialities
                              .remove(speciality.catId!);
                        }
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }
}
