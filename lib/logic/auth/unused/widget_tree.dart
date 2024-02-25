import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/logic/auth/unused/home_page.dart';
import 'package:ai_mood_tracking_application/logic/auth/unused/login_register_widgets.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
