import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/services/message_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CounsellorProfile extends StatefulWidget {
  CounsellorProfile({super.key, required this.title});
  final String title;
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<CounsellorProfile> createState() => _MyCounsellorProfileState();
}

class _MyCounsellorProfileState extends State<CounsellorProfile> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final MessageService _messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.streamUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return counsellorProfileLoadingScreen();
          }
          Map<String, dynamic> userData = snapshot.data!.docs.first.data();
          return counsellorProfileScreen(userData);
        });
  }

  Widget counsellorProfileScreen(Map<String, dynamic> userData) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(children: <Widget>[
          profilePictureContainer(),
          userDataContainer(userData),
          shareButton()
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AuthService().signOut();
        },
        label: const Text("Sign Out"),
      ),
    );
  }

  Widget profilePictureContainer() {
    return const Icon(Icons.person, size: 200);
  }

  Widget userDataContainer(Map<String, dynamic> userData) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        child: Column(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[const Text("Email"), Text(userData["email"])]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Username"),
                Text(userData["username"])
              ]),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Password"), Text("hidden")]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Counselor Code"),
                Text(userData["counselorCode"])
              ]),
        ]));
  }

  Widget shareButton() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height:
            MediaQuery.of(context).size.height * 0.05, // 80% of screen width
        color: AppColors.blueSurface,
        child: const Center(
            child:
                Text("Share app now!", style: AppTextStyles.mediumWhiteText)));
  }

  Widget counsellorProfileLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Your Students"),
      ),
      body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: [Text("Loading...")])),
    );
  }
}
