import 'package:Coretext/module/auth_module/login/view_model/login_view_model.dart';
import 'package:Coretext/splash_screen.dart';
import 'package:Coretext/firebase_options.dart';
import 'package:Coretext/module/article_module/screen/article_screen.dart';
import 'package:Coretext/module/auth_module/login/screens/login_screen.dart';
import 'package:Coretext/module/auth_module/login/screens/otp_screen.dart';
import 'package:Coretext/module/auth_module/signup/screen/quick_signup_screen.dart';
import 'package:Coretext/module/auth_module/signup/screen/register_screen.dart';
import 'package:Coretext/splash_screen.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:Coretext/utils/constants/asset_constant/asset_constant.dart';
import 'package:Coretext/utils/constants/enum_constants.dart';
import 'package:Coretext/utils/initialization_services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart';

import 'utils/bottom_bar_widget/view_model/bottom_bar_view-model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// LoginViewModel loginViewModel = Get.put(LoginViewModel());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await loginViewModel.checkAndClearLocalStorage();
  Get.put(NavigationController());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseInitialization.sharedInstance.registerNotification();
  FirebaseInitialization.sharedInstance.configLocalNotification();

  APIConfig.setAPIConfigTo(environment: AppEnvironment.production);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          textTheme:
              Theme.of(context).textTheme.apply(fontFamily: 'Montserrat'),
          inputDecorationTheme: InputDecorationTheme(
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
          ),
        ),

//  initialRoute: '/home',
        routes: {
          // '/subscription': (context) => SubscriptionScreen(),
          // "/home": (BuildContext context) => HomeScreen(),
        },
        home: SplashScreen());
  }
}
