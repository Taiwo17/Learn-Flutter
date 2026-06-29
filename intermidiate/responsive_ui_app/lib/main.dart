import 'package:flutter/material.dart';
import 'package:responsive_ui_app/responsive/desktop_scaffold.dart';
import 'package:responsive_ui_app/responsive/mobile_scaffold.dart';
import 'package:responsive_ui_app/responsive/responsive_layout.dart';
import 'package:responsive_ui_app/responsive/tablet_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: DesktopScaffold(),
      ),
    );
  }
}
