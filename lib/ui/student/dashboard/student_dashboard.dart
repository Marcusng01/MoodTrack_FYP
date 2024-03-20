import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:ai_mood_tracking_application/ui/student/message%20(OLD)/message_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  StudentDashboard({super.key, required this.title});
  final String title;
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<StudentDashboard> createState() => _MyStudentDashboardState();
}

class _MyStudentDashboardState extends State<StudentDashboard> {
  AuthService _auth = AuthService();
  FirestoreService _firestoreService = FirestoreService();

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

  Widget dashboardButtons(userData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        dashboardButton("Journaling", "You were 'Angry'", "Yesterday",
            Icons.calendar_month),
        dashboardButton(
            "Reminders", "Breath in and out", "See More", Icons.list),
        messageButton(userData, "Message Counsellor", "You: Last Message",
            "Today 3:14pm", Icons.mail),
        dashboardButton(
            "Analyse", "Generate Reports", "Click Here", Icons.pie_chart)
      ],
    );
  }

  Future<Map<String, dynamic>> counsellorData(String counselorCode) async {
    var doc = await _auth.currentUserCounsellorDoc();
    return doc.data! as Map<String, dynamic>;
  }

  Widget messageButton(userData, head, body, foot, icon) {
    return StreamBuilder(
        stream: _auth.streamSearchCounsellorDoc(userData["counsellorCode"]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          var counsellorDoc = snapshot.data!.docs.toList()[0];
          var counsellorData = counsellorDoc.data as Map<String, dynamic>;
          return ElevatedButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessageView(
                          receiverUsername: counsellorData["username"],
                          receiverUserId: counsellorData["id"])))
            },
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
        });
  }

  Widget studentDashboardScreen(userData) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: dashboardButtons(userData),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AuthService().signOut();
        },
        label: const Text("Sign Out"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.streamUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          var userDoc = snapshot.data!.docs.toList()[0];
          var userData = userDoc.data as Map<String, dynamic>;
          return studentDashboardScreen(userData);
        });
  }
}
