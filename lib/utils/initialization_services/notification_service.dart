import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:permission_handler/permission_handler.dart';

class FirebaseInitialization {
  FirebaseInitialization._privateConstructor();

  String? fcmToken;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static FirebaseInitialization sharedInstance =
      FirebaseInitialization._privateConstructor();

  Future<void> registerNotification() async {
    // storeLogToAFile({"register": "Register Notification called"});

    try {
      if (Platform.isIOS) {
        if (await Permission.notification.status != PermissionStatus.granted) {
          await Permission.notification.request();
        }
      } else {
        if (await Permission.notification.status != PermissionStatus.granted) {
          await Permission.notification.request();
        }
      }

      await FirebaseMessaging.instance.getAPNSToken();
      fcmToken = await FirebaseMessaging.instance.getToken();

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          showNotification(
            message.data,
            message.notification,
          );

          return;
        },
        onError: (error) {
          debugPrint(error.toString());
        },
      );
    } catch (e) {
      return;
    }
    return;
  }

  void configLocalNotification() async {
    // storeLogToAFile({"register": "Config Notification called"});
    //when app open
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // storeLogToAFile({"handled Tap": "App opened 123"});
      handleMessage(message.data);
    });

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // storeLogToAFile({"OnDidReceived": response.payload ?? ""});
        if ((response.payload ?? "").isNotEmpty) {
          handleMessage(jsonDecode(response.payload ?? ""));
        }
      },
    );
  }

  void handleMessage(Map<String, dynamic> messageData) async {
    // storeLogToAFile(messageData);
  }

  void showNotification(
      Map<String, dynamic> data, RemoteNotification? remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      "coretext.digital",
      'Coretext App',
      channelDescription: 'your channel description',

      playSound: true,
      // icon: "@mipmap/ic_launcher",
      enableVibration: true,
      importance: Importance.min,
      priority: Priority.defaultPriority,
      ongoing: true,
      autoCancel: true,
      // actions: <AndroidNotificationAction>[
      //    AndroidNotificationAction(
      //   'action_reply',
      //   'Reply',
      //   titleColor: Colors.green,
      //   showsUserInterface: true,
      //   inputs: [
      //     AndroidNotificationActionInput(
      //       label: 'Enter your reply',
      //     ),
      //   ],
      //   allowGeneratedReplies: true,
      // ),
      // AndroidNotificationAction(
      //   'action_accept',
      //   'Accept',
      //   titleColor: Colors.blue,
      // ),
      // ]
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    //  await flutterLocalNotificationsPlugin.show(  0,
    // 'New notification',
    // 'Flutter notification',
    // platformChannelSpecifics,
    // payload: 'item x');

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification?.title ?? "",
      remoteNotification?.body ?? '',
      platformChannelSpecifics,
      payload: jsonEncode(data),
    );
// void _showReplyDialog(BuildContext context) async {
//   List<TextEditingController> controllers = [
//     for (var i = 0; i < androidPlatformChannelSpecifics.actions!.length; i++)
//       TextEditingController(),
//   ];

//   List<Widget> inputFields = androidPlatformChannelSpecifics.actions
//       !.expand((action) => action.inputs.map((input) {
//             int index = androidPlatformChannelSpecifics.actions!.indexOf(action);
//             return TextField(
//               controller: controllers[index],
//              // decoration: InputDecoration(labelText: input.hint),
//             );
//           }))
//       .toList();

//   String userReply;

//   await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Reply to Notification'),
//       content: Column(
//         children: inputFields,
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context, null); // Cancel
//           },
//           child: Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             // Process the reply
//             userReply = inputFields
//                 .map((field) =>
//                     controllers[inputFields.indexOf(field)].text)
//                 .join(', ');
//
//             print('User replied: $userReply');
//             Navigator.pop(context, userReply); // Close the dialog
//           },
//           child: Text('Send'),
//         ),
//       ],
//     ),
//   );
// }
  }
}

// Future<void> onNotificationClick(String payload) async {
//       if (payload == 'item x') {
//           Fluttertoast.showToast(
//               msg: 'Accepted',
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.green,
//               textColor: Colors.white,
//               fontSize: 16.0
//           );
//       }
//   }

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
//  FirebaseInitialization.sharedInstance.handleMessage(message);
}
