import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../main.dart';
// class PushNotificationServices {
//   static final onClickNotification = BehaviorSubject<Map>();
//
//   static void onNotificationTap(NotificationResponse notificationResponse) {
//     Map<String, dynamic> data = jsonDecode(notificationResponse.payload!);
//     // Now you have access to the data
//     onClickNotification.add(data);
//   }
//
//   static localNotificationInitialization() {
//     AndroidInitializationSettings androidSettings =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//     DarwinInitializationSettings iosSettings =
//         const DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestCriticalPermission: true,
//             requestSoundPermission: true);
//     InitializationSettings initializationSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//     notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onNotificationTap,
//         onDidReceiveBackgroundNotificationResponse: onNotificationTap);
//   }
//
//   static void saveFcmToken() async {
//     await FirebaseMessaging.instance.getToken().then((value) async {
//       print(value);
//       await SharedFcmToken.setFcmToken(value!);
//     });
//   }
//
//   static Future firebaseCloudMessaging() async {
//     await FirebaseMessaging.instance.getInitialMessage();
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       sound: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//     );
//     bool? isNotificationOn = await SharedFcmToken.getFcmToken("notification");
//     if(isNotificationOn == null){
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         SharedFcmToken.setNotification(true);
//       } else if (settings.authorizationStatus ==
//           AuthorizationStatus.provisional) {
//         print("user granted provisonal permission");
//       } else {
//         SharedFcmToken.setNotification(false);
//       }
//     }
//   }
//
//   static void showNotification(RemoteMessage message) async {
//     AndroidNotificationDetails androidDetails =
//     const AndroidNotificationDetails(
//         "notifications-wamikas", "Wamikas",
//         priority: Priority.max, importance: Importance.max);
//     NotificationDetails notiDetails =
//     NotificationDetails(android: androidDetails);
//     await notificationsPlugin.show(
//         0, message.notification?.title, message.notification?.body, notiDetails,
//         payload: jsonEncode(message.data));
//   }
//
//   static void incomingMessage() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("on message ${message.data}data\n ${message.notification?.title}"
//           " title\n ${message.notification?.body} body \n");
//       showNotification(message);
//     });
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../SharedPrefernce/shared_pref.dart';
import '../../main.dart';


class PushNotificationServices {

  static InitializationSettings localNotificationInitialization() {
   try{
     AndroidInitializationSettings androidSettings =
     const AndroidInitializationSettings("@mipmap/ic_launcher");
     DarwinInitializationSettings iosSettings =
     const DarwinInitializationSettings(
         requestAlertPermission: true,
         requestBadgePermission: true,
         requestCriticalPermission: true,
         requestSoundPermission: true);
     InitializationSettings initializationSettings = InitializationSettings(
       android: androidSettings,
       iOS: iosSettings,
     );
     return initializationSettings;
   }
   catch(e){
     print("ab yahan par");
     print(e.toString());
     AndroidInitializationSettings androidSettings =
     const AndroidInitializationSettings("@mipmap/ic_launcher");
     DarwinInitializationSettings iosSettings =
     const DarwinInitializationSettings(
         requestAlertPermission: true,
         requestBadgePermission: true,
         requestCriticalPermission: true,
         requestSoundPermission: true);
     InitializationSettings initializationSettings = InitializationSettings(
       android: androidSettings,
       iOS: iosSettings,
     );
     return initializationSettings;
   }
  }

  static void saveFcmToken() async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      await SharedFcmToken.setFcmToken(value!);
    });
  }

  static Future firebaseCloudMessaging() async {
   try{
     await FirebaseMessaging.instance.getInitialMessage();
     FirebaseMessaging messaging = FirebaseMessaging.instance;
     NotificationSettings settings = await messaging.requestPermission(
       alert: true,
       announcement: false,
       badge: true,
       sound: true,
       carPlay: false,
       criticalAlert: false,
       provisional: false,
     );
     bool? isNotificationOn = await SharedFcmToken.getFcmToken("notification");
     if(isNotificationOn == null){
       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
         SharedFcmToken.setNotification(true);
       } else if (settings.authorizationStatus ==
           AuthorizationStatus.provisional) {
         print("user granted provisonal permission");
       } else {
         SharedFcmToken.setNotification(false);
       }
     }
   }
   catch(e){
     print("yes");
     print(e.toString());
   }
  }

    static void showNotification(RemoteMessage message) async {
  try{
    AndroidNotificationDetails androidDetails =
    const AndroidNotificationDetails(
        "notifications-wamikas", "Wamikas",
        priority: Priority.max, importance: Importance.max);
    NotificationDetails notiDetails =
    NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(
        1, message.notification?.title, message.notification?.body, notiDetails,
        payload: jsonEncode(message.data));
  }
  catch(e){
    print("kkk");
    print(e.toString());
  }
  }

  static void incomingMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("on message ${message.data}data\n ${message.notification?.title}"
          " title\n ${message.notification?.body} body \n");
      showNotification(message);
    });
  }
}


