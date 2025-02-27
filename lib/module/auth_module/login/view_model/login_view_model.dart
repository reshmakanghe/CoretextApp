import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:Coretext/module/auth_module/login/model/login_data_model.dart';
import 'package:Coretext/module/auth_module/login/screens/login_screen.dart';
import 'package:Coretext/module/auth_module/signup/model/verify_otp_data_model.dart';
import 'package:Coretext/module/auth_module/signup/screen/register_screen.dart';
import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/WebService/api_service.dart';
import 'package:Coretext/utils/WebService/end_points_constant.dart';
import 'package:Coretext/utils/constants/StringConstants/key_value_constant.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final formKey = GlobalKey<FormState>();
  var isFormValid = false.obs;
  var isLoading = false.obs;

  final formKeySignUp = GlobalKey<FormState>();
  var isFormValidSignUp = false.obs;

  var isOTPVisible = true.obs;
  var isGoogleVisible = true.obs;
  var isGoogleSignIn = false.obs;
  Rx<APIBaseModel<LoginDataModel?>?>? loginDataModel =
      RxNullable<APIBaseModel<LoginDataModel?>?>().setNull();
  Rx<APIBaseModel<VerifyOtpDataModel?>?>? verifyDataModel =
      RxNullable<APIBaseModel<VerifyOtpDataModel?>?>().setNull();

  Rx<APIBaseModel<List<LoginDataModel?>?>?> loginListDataModel =
      RxNullable<APIBaseModel<List<LoginDataModel?>?>?>().setNull();

  var isResendEnabled = false.obs;
  var resendText = 'Resend OTP'.obs;
  Timer? _timer;
  int _start = 30;
  final RxBool isOtpRequestInProgressForMobile = false.obs;
  final RxBool isOtpRequestInProgressForEmail = false.obs;

  var email = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;

  //var selectedState = ''.obs;
  void initializeSelectedState(String? state) {
    selectedState.value = state ?? '';
  } // Timer duration in seconds

  RxString selectedspeciality = ''.obs;
  RxList<int> selectedSpecialities = <int>[].obs;

  RxList<String> selectedSpecialityNames = <String>[].obs; // To store cat names
  // List<String> specialties = [
  //   "Cardiology",
  //   "Neurology",
  //   "Orthopedics",
  //   "Pediatrics",
  //   "Dermatology",
  // ];

  var isContainerVisible = false.obs;
  // Observed variable
  var states = [
    'Select State',
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    // ... Add all your states here
  ].obs;

  // Selected state (initially set to null)
  var selectedState = ''.obs;
  RxString isDoctor = ''.obs;

  void setContainerVisible(bool value) {
    isContainerVisible.value = value; // Updating the value of observed variable
  }

  void toggleVisibility() {
    isOTPVisible.value = !isOTPVisible.value;
  }

  void toggleGoogleVisibility() {
    isGoogleVisible.value = !isGoogleVisible.value;
  }

  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController loginMobileNumberController =
      TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController educationalQualificationController =
      TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController disctrictController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
  TextEditingController doctorController = TextEditingController();

  final otpControllers = List.generate(4, (index) => TextEditingController());
  String? selectedCountryName;

  Future<APIBaseModel<LoginDataModel?>?>? sendOtp(
      {String? emailId, String? googleId, String? fName, String? lName}) async {
    loginDataModel?.value = await APIService.postDataToServer<LoginDataModel?>(
        endPoint: sendOTPEndPoint,
        body: {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "email": emailId,
          "g_id": googleId
        },
        create: (dynamic json) {
          if (json != null && json is Map<String, dynamic>) {
            return LoginDataModel.fromJson(json);
          }
          return null;
        });
    return loginDataModel?.value;
  }

  Future<APIBaseModel<VerifyOtpDataModel?>?>? verifyOTP(
      {String? emailId}) async {
    verifyDataModel?.value =
        await APIService.postDataToServerForSignUp<VerifyOtpDataModel?>(
            endPoint: verifyOtpEndPoint,
            body: {
              "email_otp": passwordController.text,
              "email": emailId ?? "",
            },
            create: (dynamic json) {
              if (json != null && json is Map<String, dynamic>) {
                return VerifyOtpDataModel.fromJson(json);
              }
              return null;
            });
    return verifyDataModel?.value;
  }

  Future<APIBaseModel<LoginDataModel?>?>? login(
      {String? email, String? gID}) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    print(deviceToken);
    loginDataModel?.value = await APIService.postDataToServer<LoginDataModel?>(
        endPoint: loginEndPoint,
        body: {
          "email": email ?? "",
          "email_otp": passwordController.text,
          "fcm_token": deviceToken ?? "",
          "g_id": gID ?? ""
        },
        create: (dynamic json) {
          if (json != null && json is Map<String, dynamic>) {
            return LoginDataModel.fromJson(json);
          }
          return null;
        });

    return loginDataModel?.value;
  }

  // Future<void> storeLoginResponseInSharedPreferences({
  //   String? email,
  //   String? firstName,
  //   String? lastName,
  // }) async {
  //   print("Token--------------->${loginDataModel?.value?.responseBody?.token}");

  //   if (loginDataModel?.value?.status == true) {
  //     // Prepare the session data by converting the login data model to JSON
  //     Map<String, dynamic> sessionData = loginDataModel?.value?.toJson(
  //           loginDataModel?.value?.responseBody?.toJson(),
  //         ) ??
  //         {};

  //     // Add the additional data (email, firstName, lastName) to the session
  //     sessionData['email'] = email; // Add email
  //     sessionData['firstName'] = firstName; // Add first name
  //     sessionData['lastName'] = lastName; // Add last name

  //     // Store the updated session data in SharedPreferences
  //     await CoreTextAppGlobal.instance.preferences?.setString(
  //       loginSession,
  //       jsonEncode(sessionData),
  //     );

  //     print("Updated Session Data: $sessionData");
  //   }

  //   return;
  // }

  Future<void> storeLoginResponseInSharedPreferences(
      {required bool isLogin}) async {
    if (isLogin) {
      // Store the login response
      print(
          "Token--------------->${loginDataModel?.value?.responseBody?.token}");
      if ((loginDataModel?.value?.status == true) ||
          (loginDataModel?.value?.message ==
              "Unable to login, user in pending state or email not verified")) {
        await CoreTextAppGlobal.instance.preferences?.setString(
          loginSession,
          jsonEncode(loginDataModel?.value
              ?.toJson(loginDataModel?.value?.responseBody?.toJson())),
        );
        print("Login session saved");
      }
    } else {
      // Store the verify OTP response
      print(
          "Token--------------->${verifyDataModel?.value?.responseBody?.token}");
      if (verifyDataModel?.value?.status == true) {
        await CoreTextAppGlobal.instance.preferences?.setString(
          loginSession,
          jsonEncode(verifyDataModel?.value
              ?.toJson(verifyDataModel?.value?.responseBody?.toJson())),
        );
        print("Verify session saved");
      }
    }
  }

  // Future<void> storeLoginResponseInSharedPreferences() async {
  //   print("Token--------------->${loginDataModel?.value?.responseBody?.token}");
  //   if (loginDataModel?.value?.status == true) {
  //     await CoreTextAppGlobal.instance.preferences?.setString(
  //         loginSession,
  //         jsonEncode(
  //           loginDataModel?.value
  //               ?.toJson(loginDataModel?.value?.responseBody?.toJson()),
  //         ));
  //     print(loginSession);
  //   }

  //   return;
  // }

  bool checkForLoginSessionExists() {
    String? loginSessionValue =
        CoreTextAppGlobal.instance.preferences?.getString(loginSession);
    print("Response ----------------->$loginSessionValue");
    if (loginSessionValue != null) {
      Map<String, dynamic>? jsonData;
      try {
        jsonData = jsonDecode(loginSessionValue) as Map<String, dynamic>?;
      } catch (e) {
        print("Error decoding signup session JSON: $e");
      }

      if (jsonData != null) {
        CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value =
            APIBaseModel.fromJson(
          jsonData,
          true,
          (json) => LoginDataModel.fromJson(json as Map<String, dynamic>),
        );
        return true;
      }
    }
    return false;
  }

  bool logoutUser() {
    CoreTextAppGlobal.instance.preferences?.remove(loginSession);
    Navigator.of(Get.context!).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    return true;
  }

  Future<APIBaseModel<LoginDataModel?>?>? signUp({
    String? appSignature,
    String? gID,
    int? userId,
  }) async {
    try {
      // Get the device token
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      // Convert RxString value to int (1 if "Yes", 0 if "No")
      int isIntDoctor = isDoctor.value == "Yes" ? 1 : 0;

      // Prepare the body
      Map<String, dynamic> body = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "email": emailController.text,
        "mobile": mobileNumberController.text,
        "role": "user",
        "is_doctor": isIntDoctor,
        "speciality": specialityController.text,
        "cat_id": selectedSpecialities
            .toList(), // Pass the selected cat IDs as a comma-separated string
        "updated_by": userId,
        "state":
            selectedState.value != 'Select State' ? selectedState.value : "",
        "fcm_token": deviceToken,
        "user_id": userId,
      };

      // Send request to server
      loginDataModel?.value =
          await APIService.postDataToServer<LoginDataModel?>(
        endPoint: signupEndPoint,
        body: body,
        create: (dynamic json) {
          return LoginDataModel.fromJson(json);
        },
      );
    } catch (e) {
      debugPrint("Error during signUp: $e");
      return null;
    }
    return loginDataModel?.value;
  }

  bool validate() {
    // Check if mobile number is valid
    RegExp regex9Digits = RegExp(r'^\d{9}$');
    RegExp regex10Digits = RegExp(r'^\d{10}$');
    if (mobileNumberController.text.isEmpty ||
        (!regex9Digits.hasMatch(mobileNumberController.text) &&
            !regex10Digits.hasMatch(mobileNumberController.text))) {
      return false;
    }

    // Check if email is valid
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (emailController.text.isEmpty ||
        !emailRegex.hasMatch(emailController.text)) {
      return false;
    }

    // Check if ZIP code is valid
    RegExp zipRegex = RegExp(r'^\d{4,6}$');
    if (zipcodeController.text.isEmpty ||
        !zipRegex.hasMatch(zipcodeController.text)) {
      return false;
    }

    return true; // All fields are filled and pass validation
  }

// Login with Google

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignInn = GoogleSignIn();

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    try {
      // Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Sign-in was canceled by the user
        print("Google Sign-In canceled by user.");
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the new credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      print("Google Sign-In successful. User: ${user?.email}");
      return user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    await googleSignInn.signOut();
    print("User signed out of Google account");
  }

  //Resend otp timer
  void startTimer() {
    _start = 30; // Reset timer duration
    isResendEnabled.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start < 1) {
        timer.cancel();
        isResendEnabled.value = true;
        resendText.value = 'Resend OTP';
      } else {
        _start--;
        resendText.value = 'Login';
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String? validateEmail(String? value) {
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

  void saveRegistrationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('lastName', lastNameController.text);
    await prefs.setString('email', emailController.text);
  }

// Declare navigateToRegister before usage
  void navigateToRegister() {
    // Use GetX navigation to push the Register screen
    Get.to(() => Register(
          emailId: email.value,
          userId: loginDataModel?.value?.responseBody?.userId ?? 0,
          firstName: firstName.value,
          lastName: lastName.value,
        ));
  }

  void loadRegistrationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load stored values if available
    String storedEmail = prefs.getString('email') ?? '';
    String storedFirstName = prefs.getString('firstName') ?? '';
    String storedLastName = prefs.getString('lastName') ?? '';

    // Set the controllers only if they are empty
    if (emailController.text.isEmpty && storedEmail.isNotEmpty) {
      emailController.text = storedEmail;
    }

    if (firstNameController.text.isEmpty && storedFirstName.isNotEmpty) {
      firstNameController.text = storedFirstName;
    }

    if (lastNameController.text.isEmpty && storedLastName.isNotEmpty) {
      lastNameController.text = storedLastName;
    }
  }

  Future<void> checkAndClearLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the token is null
    String? token =
        prefs.getString('token'); // Replace 'token' with your actual key
    if (token == null) {
      // Clear local storage if it's the first time
      await prefs.clear(); // This will clear all stored preferences
    }
  }

// Define debounce function
  void handleButtonPress(Future<void> Function() callback) async {
    if (!isLoading.value) {
      // Only proceed if not already loading
      isLoading.value = true;
      try {
        await callback();
      } finally {
        isLoading.value = false; // Ensure loading stops
      }
    }
  }
}
