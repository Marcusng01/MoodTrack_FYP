import 'package:ai_mood_tracking_application/ui/authentication/auth_gate.dart';
import 'package:ai_mood_tracking_application/ui/authentication/register/register_view.dart';
import 'package:ai_mood_tracking_application/ui/authentication/register_success/register_success_view.dart';
import 'package:ai_mood_tracking_application/ui/authentication/select_user_type/select_user_type_view.dart';
import 'package:ai_mood_tracking_application/ui/student/analyse/analyse_view.dart';
import 'package:ai_mood_tracking_application/ui/student/dashboard/student_dashboard.dart';
import 'package:ai_mood_tracking_application/ui/student/journaling/journal_calendar/journal_calendar_view.dart';
import 'package:ai_mood_tracking_application/ui/student/journaling/journal_reflect/journal_reflect_view.dart';
import 'package:ai_mood_tracking_application/ui/student/journaling/journal_result/journal_result_view.dart';
import 'package:ai_mood_tracking_application/ui/student/journaling/journal_writing/journal_writing_view.dart';
import 'package:ai_mood_tracking_application/ui/student/message%20(OLD)/message_view.dart';
import 'package:ai_mood_tracking_application/ui/student/reminders/reminders_view.dart';
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
            const RegisterView(title: "Register"),
        "/selectUserType/Register/Success": (context) =>
            const RegisterSuccessView(title: "Registered Successfully!"),
        "/Student/Dashboard": (context) => StudentDashboard(title: "Dashboard"),
        "/Student/Journaling": (context) =>
            JournalCalendarView(title: "Journal"),
        "/Student/Journaling/Reflect": (context) =>
            JournalReflectView(title: "Reflect"),
        "/Student/Journaling/Writing": (context) => JournalWritingView(),
        "/Student/Journaling/Result": (context) => JournalResultView(),
        "/Student/Reminders": (context) =>
            RemindersView(title: "Reminders of Past Reflections"),
        "/Student/Message Counsellor": (context) => const MessageView(
              receiverUsername: '',
              receiverUserId: '',
            ),
        "/Student/Analyse": (context) => AnalyseView(title: "Analyse"),
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
