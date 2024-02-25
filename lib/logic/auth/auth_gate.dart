import 'package:ai_mood_tracking_application/UI/authentication/login.dart';
import 'package:ai_mood_tracking_application/UI/counsellor/counsellor_dashboard.dart';
import 'package:ai_mood_tracking_application/UI/student/student_dashboard.dart';
import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // String jsonString = jsonEncode(Auth().currentUser?.uid);
          return FutureBuilder(
              future: Auth().getUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  userData = snapshot.data!.data() as Map<String, dynamic>;
                  if (userData["isCounsellor"]) {
                    return CounsellorDashboard(title: "Welcome Counsellor");
                  } else {
                    return StudentDashboard(title: "Welcome Student");
                  }
                } else {
                  return const Login(title: "Login");
                }
              });
        } else {
          return const Login(title: "Login");
        }
      },
    );
  }
}
