import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


import 'SplashScreen.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 // log(message.toMap().toString());
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //log('Handling a background message ${message.messageId}');
}

void onBackgroundNotificationResponse(NotificationResponse response) {
  //log("Background notification clicked: ${response.payload}");
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> showFlutterNotification(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('channel_id', 'channel_name',
      importance: Importance.max, priority: Priority.high, showWhen: false);

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
        presentSound: true),
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    message.notification?.title ?? "",
    message.notification?.body ?? "",
    platformChannelSpecifics,
    payload: message.data.toString(), // Store payload for click actions
  );
}

Future<void> setupLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          //route
        }
      },
      onDidReceiveBackgroundNotificationResponse:
      onBackgroundNotificationResponse);
}

void registerNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await setupLocalNotifications();

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      //log(message.toMap().toString());
      //route
    }
  });

  //foregroud
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //log(message.toMap().toString());
    showFlutterNotification(message);
  });

  //background
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //log(message.toMap().toString());
    //route
  });
}
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xFF73CDEF)
  ));

  WidgetsFlutterBinding.ensureInitialized();
 /*// OneSignal.Debug.setLogLevel(OSLogLevel.verbose);*/
  OneSignal.initialize("e9881458-c1eb-4d0b-95d6-671f03765704");
  OneSignal.Notifications.requestPermission(true);
  await Firebase.initializeApp();
  registerNotifications();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await GetStorage.init();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'SplashScreen',
    builder: EasyLoading.init(),
     theme: ThemeData(
    primaryColor: Color(0xFF73CDEF),
  ),
    routes: {
      'SplashScreen': (context) => const SplashScreen(),
          },
  ));
}
