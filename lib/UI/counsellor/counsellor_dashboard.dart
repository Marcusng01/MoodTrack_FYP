import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CounsellorDashboard extends StatefulWidget {
  CounsellorDashboard({super.key, required this.title});
  final String title;
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<CounsellorDashboard> createState() => _MyCounsellorDashboardState();
}

class _MyCounsellorDashboardState extends State<CounsellorDashboard> {
  Widget counsellorStudentListItem() {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/Student/Message Counsellor');
        },
        child: const Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(
              "Student One",
              style: AppTextStyles.largeBlackText,
            ),
            subtitle: Text("You: Last Message",
                style: AppTextStyles.mediumGreyText,
                overflow: TextOverflow.ellipsis),
          ),
        ));
  }

  Widget counsellorStudentListHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: AppColors.lightBlueSurface,
      ),
      child: const Text(
        "Your Students",
        style: AppTextStyles.largeBlueText,
      ),
    );
  }

  Widget counsellorStudentListBody() {
    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            /*TO DO: Change itemCount */
            itemCount: 5,
            itemBuilder: (BuildContext ctxt, int index) {
              return counsellorStudentListItem();
            }),
      ),
    );
  }

  Widget counsellorStudentList() {
    return Column(children: <Widget>[
      counsellorStudentListHeader(),
      counsellorStudentListBody(),
    ]);
  }

  Widget counsellorDashboardScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: counsellorStudentList(),
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
    return counsellorDashboardScreen();
  }
}
