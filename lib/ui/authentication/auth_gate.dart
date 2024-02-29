import 'package:ai_mood_tracking_application/UI/counsellor/counsellor_dashboard.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/ui/authentication/login/login_view.dart';
import 'package:ai_mood_tracking_application/ui/student/dashboard/student_dashboard.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Map<String, dynamic> userData;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // String jsonString = jsonEncode(Auth().currentUser?.uid);
          return FutureBuilder(
              future: _auth.getUserDetails(),
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
                  return const LoginView(title: "Login");
                }
              });
        } else {
          return const LoginView(title: "Login");
        }
      },
    );
  }
}
