import 'package:ai_mood_tracking_application/UI/authentication/register.dart';
import 'package:ai_mood_tracking_application/UI/authentication/register_success_screen.dart';
import 'package:ai_mood_tracking_application/UI/authentication/select_user_type.dart';
import 'package:ai_mood_tracking_application/UI/student/journaling/result_screen.dart';
import 'package:ai_mood_tracking_application/UI/student/journaling/student_journaling_screen.dart';
import 'package:ai_mood_tracking_application/UI/student/journaling/writing_screen.dart';
import 'package:ai_mood_tracking_application/UI/student/reflect/student_reflect_screen.dart';
import 'package:ai_mood_tracking_application/UI/student/reflect/student_reminders_screen.dart';
import 'package:ai_mood_tracking_application/UI/student/student_analyse_screen.dart';
import 'package:ai_mood_tracking_application/UI/student/student_dashboard.dart';
import 'package:ai_mood_tracking_application/UI/student/student_message_screen.dart';
import 'package:ai_mood_tracking_application/logic/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCTaP81iJDv2LyamGMafXG-v3HkmbwbhKc",
      appId: "1:307929323963:android:521038d0f15622d59c8c9e",
      messagingSenderId: "307929323963",
      projectId: "ai-mood-tracking-app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Mood Tracking Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: "/",
      home: const AuthGate(),
      routes: {
        "/selectUserType": (context) =>
            const SelectUserType(title: "Select User Type"),
        "/selectUserType/Register": (context) =>
            const Register(title: "Register"),
        "/selectUserType/Register/Success": (context) =>
            const RegisterSuccessScreen(title: "Registered Successfully!"),
        "/Student/Dashboard": (context) => StudentDashboard(title: "Dashboard"),
        "/Student/Journaling": (context) =>
            StudentJournalingScreen(title: "Journal"),
        "/Student/Journaling/Writing": (context) => WritingScreen(),
        "/Student/Journaling/Result": (context) => ResultScreen(),
        "/Student/Reminders": (context) =>
            StudentRemindersScreen(title: "Reminders of Past Reflections"),
        "/Student/Message Counsellor": (context) =>
            StudentMessageScreen(title: "Message"),
        "/Student/Analyse": (context) => StudentAnalyseScreen(title: "Analyse"),
        "/Student/Reflect": (context) => StudentReflectScreen(title: "Reflect"),
      },
      // onGenerateRoute: (settings) {
      //   if (settings.name == '/Student/Journaling/Writing') {
      //     final args = settings.arguments as WritingScreenArguments;
      //     return MaterialPageRoute(
      //         builder: (context) => WritingScreen(
      //             date: args.date,
      //             rating: args.rating,
      //             journal: args.journal));
      //   }
      // }
    );
  }
}
