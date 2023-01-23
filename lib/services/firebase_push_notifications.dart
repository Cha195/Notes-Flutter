import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utilities/push_notification_model.dart';

class FirebasePushNotifications {
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  void initialize() {
    registerNotification();
    checkForInitialMessage();
  }

  registerNotification() async {
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
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
