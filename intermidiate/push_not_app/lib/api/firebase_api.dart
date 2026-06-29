import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_not_app/main.dart';

class FirebaseApi {
  // create an instance of Firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token from the device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token (normally you would send this to your servers)
    print('Token: $fCMToken');

    // initialize further settings for push notification
    initPushNotification();
  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // if the message is null, do nothing

    if (message == null) return;

    // navigate to new screen when message is received and user tap notifications
    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  // function to initialize foreground and background settings
  Future initPushNotification() async {
    // handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
