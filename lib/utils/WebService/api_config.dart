import 'package:Coretext/utils/constants/enum_constants.dart';
import 'package:Coretext/utils/initialization_services/singleton_service.dart';
import 'package:get/get.dart';

class RxNullable<T> {
  Rx<T> setNull() => (null as T).obs;
}

class APIConfig {
  static String baseUrl = "";
  static String imagePath = "";
  static String categoryPath = "";
  static String pollPath = "";
  static String adPath = "";

  // LoginViewModel loginViewModel = Get.put(LoginViewModel());

  static setAPIConfigTo({required AppEnvironment environment}) {
    switch (environment) {
      case AppEnvironment.production:
        baseUrl = "https://coretext.in/api/";
        imagePath = "https://coretext.in/asset/article/";
        categoryPath = "http://coretext.in/asset/category/";
        pollPath = "https://coretext.in/asset/poll_img/";
        adPath = "https://coretext.in/asset/ads/";

        break;
      case AppEnvironment.development:
        baseUrl = "https://coretext.in/api/";
        // "http://192.168.1.14:8002/api/";
        // "http://192.168.0.117:8001/api/";

        imagePath = "https://coretext.in/asset/article/";
        categoryPath = "http://coretext.in/asset/category/";
        pollPath = "https://coretext.in/asset/poll_img/";
        adPath = "https://coretext.in/asset/ads/";

        // "http://192.168.1.14:8002/asset/exam_image/";

        break;
      case AppEnvironment.uat:
        baseUrl = "";
        break;
      case AppEnvironment.qa:
        baseUrl = "";
        break;
    }
  }

  static Map<String, String> getRequestHeader(
      {bool? encodeJson, String? authToken}) {
    Map<String, String> requestHeader = {
      "Content-Type": (encodeJson == false
          ? 'application/x-www-form-urlencoded'
          : "application/json")
    };
    //Set For Authorization token

    requestHeader["Authorization"] =
        "Bearer ${CoreTextAppGlobal.instance.loginViewModel.loginDataModel?.value?.responseBody?.token}";

    return requestHeader;
  }
}
