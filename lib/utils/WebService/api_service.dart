import 'dart:convert';

import 'package:Coretext/utils/WebService/api_base_model.dart';
import 'package:Coretext/utils/WebService/api_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class APIService {
  // LoginViewModel loginViewModel = Get.put(LoginViewModel());
  //GET Method
  static Future<APIBaseModel<T>?> getDataFromServer<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    required T? Function(dynamic)? create,
  }) async {
    try {
      debugPrint(APIConfig.baseUrl + endPoint);
      http.Response httpResponse = await http.get(
        Uri.parse(
          APIConfig.baseUrl + endPoint,
        ),
        headers: APIConfig.getRequestHeader(),
      );
      if (httpResponse.statusCode == 200) {
        debugPrint(httpResponse.body.toString());
        return APIBaseModel<T>.fromJson(
            jsonDecode(httpResponse.body), true, create);
      } else {
        ErrorModel errorModel =
            ErrorModel.fromJson(jsonDecode(httpResponse.body));
        Fluttertoast.showToast(
          msg: errorModel.message ?? "", // Display the error message
          toastLength:
              Toast.LENGTH_SHORT, // Duration for which the toast is visible
          gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
          backgroundColor: const Color.fromARGB(
              255, 0, 0, 0), // Background color of the toast
          textColor: Colors.white, // Text color of the toast
        );
        return null;
        // SnackBar errorSnackBar =
        //     SnackBar(content: Text(errorModel.message ?? ""));
        // ScaffoldMessenger.of(Get.context!).showSnackBar(errorSnackBar);
        // return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<APIBaseModel<T>?> getDataFromServerWithoutErrorModel<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    required T? Function(dynamic)? create,
  }) async {
    try {
      debugPrint(APIConfig.baseUrl + endPoint);
      http.Response httpResponse = await http.get(
        Uri.parse(
          APIConfig.baseUrl + endPoint,
        ),
        headers: APIConfig.getRequestHeader(),
      );
      if (httpResponse.statusCode == 200) {
        debugPrint(httpResponse.body.toString());
        return APIBaseModel<T>.fromJson(
            jsonDecode(httpResponse.body), true, create);
      } else {
        // ErrorModel errorModel =
        //     ErrorModel.fromJson(jsonDecode(httpResponse.body));
        // SnackBar errorSnackBar =
        //     SnackBar(content: Text(errorModel.message ?? ""));
        // ScaffoldMessenger.of(Get.context!).showSnackBar(errorSnackBar);
        // return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  static Future<APIBaseModel<T?>?> postDataToServer<T>(
      {required String endPoint,
      dynamic body,
      bool? encodeBody,
      required T? Function(dynamic)? create}) async {
    try {
      debugPrint(APIConfig.baseUrl + endPoint);

      http.Request request = http.Request(
        'POST',
        Uri.parse(APIConfig.baseUrl + endPoint),
      );
      request.headers.addAll(
        APIConfig.getRequestHeader(encodeJson: encodeBody),
      );
      if (encodeBody == false) {
        request.bodyFields = Map.from(body.map<String, dynamic>(
            (key, value) => MapEntry(key.toString(), value.toString())));
      } else {
        request.body = jsonEncode(body);
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseString = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseString);
        return APIBaseModel<T>.fromJson(jsonResponse, true, create);
      } else {
        final responseString = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseString);
        if (jsonResponse['data'] != null &&
            jsonResponse['data']['user_id'] != null) {
          int userId = jsonResponse['data']['user_id'];
          print('User ID: $userId'); // You can use this userId as needed
        }
        return APIBaseModel<T>.fromJson(jsonResponse, false, create);
        // if (jsonResponse['data'] != null &&
        //     jsonResponse['data']['user_id'] != null) {
        //   int userId = jsonResponse['data']['user_id'];
        //   print('User ID: $userId'); // You can use this userId as needed
        // }
        // return APIBaseModel<T>.fromJson(jsonResponse, false);
      }
    } catch (e) {
      debugPrint(e.toString());
      return APIBaseModel<T>.fromJson(jsonDecode("{}"), false);
    }
  }

  static Future<APIBaseModel<T?>?> postDataToServerForSignUp<T>({
    required String endPoint,
    dynamic body,
    bool? encodeBody,
    required T? Function(dynamic)? create,
  }) async {
    try {
      debugPrint(APIConfig.baseUrl + endPoint);

      http.Request request = http.Request(
        'POST',
        Uri.parse(APIConfig.baseUrl + endPoint),
      );
      request.headers.addAll(
        APIConfig.getRequestHeader(encodeJson: encodeBody),
      );
      if (encodeBody == false) {
        request.bodyFields = Map.from(body.map<String, dynamic>(
            (key, value) => MapEntry(key.toString(), value.toString())));
      } else {
        request.body = jsonEncode(body);
      }

      http.StreamedResponse response = await request.send();
      final responseString = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseString);

      // Compare based on the 'message' field from the response
      if (jsonResponse["message"] ==
          "Email verified successfully, please sign up") {
        // Handle successful case (message contains "Success")
        return APIBaseModel<T>.fromJson(jsonResponse, true, create);
      } else {
        // Handle other cases (message doesn't contain "Success")
        return APIBaseModel<T>.fromJson(jsonResponse, false);
      }
    } catch (e) {
      debugPrint(e.toString());
      return APIBaseModel<T>.fromJson(jsonDecode("{}"), false);
    }
  }

  // //POST Method
  // static Future<APIBaseModel<T?>?> postDataToServer<T>(
  //     {required String endPoint,
  //     dynamic body,
  //     bool? encodeBody,
  //     required T? Function(dynamic)? create}) async {
  //   try {
  //     debugPrint(APIConfig.baseUrl + endPoint);

  //     http.Request request = http.Request(
  //       'POST',
  //       Uri.parse(APIConfig.baseUrl + endPoint),
  //     );
  //     request.headers.addAll(
  //       APIConfig.getRequestHeader(encodeJson: encodeBody),
  //     );
  //     if (encodeBody == false) {
  //       request.bodyFields = Map.from(body.map<String, dynamic>(
  //           (key, value) => MapEntry(key.toString(), value.toString())));
  //     } else {
  //       request.body = jsonEncode(body);
  //     }

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return APIBaseModel<T>.fromJson(
  //           jsonDecode((await response.stream.bytesToString())), true, create);
  //     } else {
  //       String responseString = (await response.stream.bytesToString());
  //       return APIBaseModel<T>.fromJson(jsonDecode(responseString), false);
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return APIBaseModel<T>.fromJson(jsonDecode("{}"), false);
  //   }
  // }

  //Patch Method
  static Future<APIBaseModel<T>> patchDataToServer<T>(
      {required String endPoint,
      Map<String, dynamic>? body,
      required T? Function(dynamic)? create}) async {
    http.Response httpResponse = await http.patch(
      Uri.parse(
        APIConfig.baseUrl + endPoint,
      ),
      headers: APIConfig.getRequestHeader(),
      body: jsonEncode(body),
    );
    if (httpResponse.statusCode == 200) {
      return APIBaseModel<T>.fromJson(
          jsonDecode(httpResponse.body), true, create);
    } else {
      return APIBaseModel<T>.fromJson(jsonDecode(httpResponse.body), false);
    }
  }

  //Patch Method
  static Future<APIBaseModel<T>> putDataToServer<T>(
      {required String endPoint,
      Map<String, dynamic>? body,
      required T? Function(dynamic)? create}) async {
    http.Response httpResponse = await http.put(
      Uri.parse(
        APIConfig.baseUrl + endPoint,
      ),
      headers: APIConfig.getRequestHeader(),
      body: jsonEncode(body),
    );
    if (httpResponse.statusCode == 200) {
      return APIBaseModel<T>.fromJson(
          jsonDecode(httpResponse.body), true, create);
    } else {
      return APIBaseModel<T>.fromJson(jsonDecode(httpResponse.body), false);
    }
  }
  //Multipart POST Method
  // static Future<APIBaseModel<T?>?> multipartPostDataToServer<T>({
  //   required String endPoint,
  //   required bool isProfilePic,
  //   Map<String, String>? body,
  //   List<MultipartDataBody>? files,
  //   bool? encodeBody,
  //   required T? Function(dynamic)? create,
  // }) async {
  //   try {
  //     debugPrint(APIConfig.baseUrl + endPoint);

  //     http.MultipartRequest multipartRequest = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(APIConfig.baseUrl + endPoint),
  //     );
  //     multipartRequest.headers.addAll(
  //       APIConfig.getRequestHeader(encodeJson: encodeBody),
  //     );
  //     multipartRequest.fields.addAll(body ?? {});
  //     if (files != null) {
  //       for (int imageCounter = 0;
  //           imageCounter < files.length;
  //           imageCounter++) {
  //         File element = File(files[imageCounter].value);

  //         http.MultipartFile dataFile = await http.MultipartFile.fromPath(
  //           files[imageCounter].key,
  //           element.path,
  //           filename: element.path.split("/").last,
  //           // contentType: MediaType(
  //           //     "image", element.path.split("/").last.split(".").last),
  //         );
  //         multipartRequest.files.add(dataFile);
  //       }
  //     }
  //     http.StreamedResponse response = await multipartRequest.send();

  //     if (response.statusCode == 200) {
  //       return APIBaseModel<T>.fromJson(
  //           jsonDecode((await response.stream.bytesToString())), true, create);
  //     } else {
  //       String responseString = (await response.stream.bytesToString());
  //       return APIBaseModel<T>.fromJson(jsonDecode(responseString), false);
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return APIBaseModel<T>.fromJson(jsonDecode("{}"), false);
  //   }
  // }

  //Multipart Patch Method

  // static Future<APIBaseModel<T>> multipartPatchDataToServer<T>(
  //     {required String endPoint,
  //     required bool isProfilePic,
  //     Map<String, String>? body,
  //     List<MultipartDataBody>? files,
  //     required T? Function(dynamic)? create}) async {
  //   http.MultipartRequest multipartRequest = http.MultipartRequest(
  //     "PATCH",
  //     Uri.parse(
  //       APIConfig.baseUrl + endPoint,
  //     ),
  //   );
  //   multipartRequest.headers.addAll(
  //     APIConfig.getRequestHeader(),
  //   );
  //   multipartRequest.fields.addAll(body ?? {});
  //   if (files != null) {
  //     for (int imageCounter = 0; imageCounter < files.length; imageCounter++) {
  //       File element = File(files[imageCounter].value);

  //       http.MultipartFile dataFile = await http.MultipartFile.fromPath(
  //         files[imageCounter].key,
  //         element.path,
  //         filename: element.path.split("/").last,
  //         // contentType:
  //         //     MediaType("image", element.path.split("/").last.split(".").last),
  //       );
  //       multipartRequest.files.add(dataFile);
  //     }
  //   }

  //   http.StreamedResponse response = await multipartRequest.send();

  //   if (response.statusCode == 200) {
  //     return APIBaseModel<T>.fromJson(
  //         jsonDecode((await response.stream.bytesToString())), true, create);
  //   } else {
  //     String responseString = (await response.stream.bytesToString());
  //     return APIBaseModel<T>.fromJson(jsonDecode(responseString), false);
  //   }
  // }

  static Future<APIBaseModel<T?>?> postArrayDataToServer<T>(
      {required String endPoint,
      List<Map<String, dynamic>>? body,
      bool? encodeBody,
      required T? Function(dynamic)? create}) async {
    try {
      debugPrint(APIConfig.baseUrl + endPoint);

      http.Request request = http.Request(
        'POST',
        Uri.parse(APIConfig.baseUrl + endPoint),
      );
      request.headers.addAll(
        APIConfig.getRequestHeader(encodeJson: encodeBody),
      );

      if (body != null && encodeBody == false) {
        // If not encoding body, iterate over the list and add fields
        for (var item in body) {
          request.bodyFields = Map.from(item.map<String, dynamic>(
              (key, value) => MapEntry(key.toString(), value.toString())));
        }
      } else if (body != null) {
        request.body = jsonEncode(
            body); // If encoding body, directly encode the list to JSON
      }

      http.StreamedResponse response = await request.send();
      print(response);

      if (response.statusCode == 200) {
        return APIBaseModel<T>.fromJson(
            jsonDecode((await response.stream.bytesToString())), true, create);
      } else {
        String responseString = (await response.stream.bytesToString());

        return APIBaseModel<T>.fromJson(jsonDecode(responseString), false);
      }
    } catch (e) {
      debugPrint(e.toString());
      return APIBaseModel<T>.fromJson(jsonDecode("{}"), false);
    }
  }

  static Future<APIBaseModel<T?>?> deleteDataFromServer<T>({
    required String endPoint,
    dynamic body,
    bool? encodeBody,
    required T? Function(dynamic)? create,
  }) async {
    try {
      http.Request request = http.Request(
        'DELETE',
        Uri.parse(APIConfig.baseUrl + endPoint),
      );
      request.headers.addAll(
        APIConfig.getRequestHeader(encodeJson: encodeBody),
      );

      if (encodeBody == false) {
        request.bodyFields = Map.from(body.map<String, dynamic>(
            (key, value) => MapEntry(key.toString(), value.toString())));
      } else {
        request.body = jsonEncode(body);
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return APIBaseModel<T>.fromJson(
            jsonDecode(await response.stream.bytesToString()), true);
      } else {
        String responseString = await response.stream.bytesToString();
        return APIBaseModel<T>.fromJson(jsonDecode(responseString), false);
      }
    } catch (e) {
      debugPrint(e.toString());
      return APIBaseModel<T>.fromJson(jsonDecode("{}"), false);
    }
  }

// other method
}
