// import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utilities/push_notification_model.dart';

class FirebasePushNotifications {
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  void initialize() {
    registerNotification();
    checkForInitialMessage();
  }

  registerNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // IOS Settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // FLN Initialzation settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize FLN
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create channel for Android Heads-up notification
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    // dev.log((await _messaging.getToken()).toString());

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    icon: android.smallIcon,
                    importance: Importance.max),
              ));
        }

        _notificationInfo = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );

      _notificationInfo = notification;
    }
  }
}
