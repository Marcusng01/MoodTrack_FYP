import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  StudentDashboard({super.key, required this.title});
  final String title;
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<StudentDashboard> createState() => _MyStudentDashboardState();
}

class _MyStudentDashboardState extends State<StudentDashboard> {
  Widget dashboadButtonText(head, body, foot) {
    return SizedBox(
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(head,
              style: AppTextStyles.largeBlueText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          Text(body,
              style: AppTextStyles.mediumBlackText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          Text(foot,
              style: AppTextStyles.mediumGreyText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget dashboardButtonIcon(icon) {
    return Icon(
      icon,
      color: AppColors.blueSurface,
      size: 45,
    );
  }

  Widget dashboardButton(head, body, foot, icon) {
    return ElevatedButton(
      onPressed: () => {Navigator.pushNamed(context, '/Student/$head')},
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            dashboadButtonText(head, body, foot),
            dashboardButtonIcon(icon)
          ],
        ),
      ),
    );
  }

  Widget dashboardButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        dashboardButton("Journaling", "You were 'Angry'", "Yesterday",
            Icons.calendar_month),
        dashboardButton(
            "Reminders", "Breath in and out", "See More", Icons.list),
        dashboardButton("Message Counsellor", "You: Last Message",
            "Today 3:14pm", Icons.mail),
        dashboardButton(
            "Analyse", "Generate Reports", "Click Here", Icons.pie_chart)
      ],
    );
  }

  Widget studentDashboardScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: dashboardButtons(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Auth().signOut();
        },
        label: const Text("Sign Out"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return studentDashboardScreen();
  }
}
