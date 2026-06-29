import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:push_not_app/api/firebase_api.dart';
import 'package:push_not_app/firebase_options.dart';
import 'package:push_not_app/pages/home_page.dart';
import 'package:push_not_app/pages/notification_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      navigatorKey: navigatorKey,
      routes: {'/notification_screen': (context) => NotificationPage()},
    );
  }
}
