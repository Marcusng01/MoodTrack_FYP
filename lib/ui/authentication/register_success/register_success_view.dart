import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterSuccessView extends StatefulWidget {
  const RegisterSuccessView({super.key, required this.title});
  final String title;
  @override
  State<RegisterSuccessView> createState() => _MyRegisterSuccessViewState();
}

class _MyRegisterSuccessViewState extends State<RegisterSuccessView> {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    final String username = args['username'];
    final bool isCounsellor = args['isCounsellor'];
    final String counselorCode = args['counselorCode'];
    DocumentSnapshot correspondingCounsellor;

    if (isCounsellor) {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            success(username, isCounsellor),
            counselor(context, counselorCode),
          ],
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (Route<dynamic> route) => false,
            );
          },
          label: const Text("Next"),
        ),
      );
    } else {
      return FutureBuilder(
          future: AuthService().searchCounsellorDoc(counselorCode),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              correspondingCounsellor = snapshot.data!;
              return Scaffold(
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    success(username, isCounsellor),
                    student(correspondingCounsellor['username'])
                  ],
                )),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                  label: const Text("Next"),
                ),
              );
            }
          });
    }
  }
}

Widget counselor(context, counselorCode) {
  SnackBar snackBar = const SnackBar(
    content: Text("Copied to Clipboard"),
  );
  return Column(
    children: [
      const Text("Your Counselor Code", style: AppTextStyles.mediumBlueText),
      Text(counselorCode, style: AppTextStyles.mediumBlackText),
      IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: counselorCode));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    ],
  );
}

Widget student(counselorUsername) {
  return Column(
    children: [
      const Text("Your Counselor is", style: AppTextStyles.mediumBlueText),
      Text(counselorUsername, style: AppTextStyles.mediumBlackText),
    ],
  );
}

Widget success(username, isCounselor) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Welcome to AI Mood Tracker!",
          style: AppTextStyles.mediumBlueText),
      Text(username, style: AppTextStyles.mediumBlackText),
    ],
  );
}
