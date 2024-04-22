import 'package:ai_mood_tracking_application/commons/ProfilePictureClipper.dart';
import 'package:ai_mood_tracking_application/commons/profile_button.dart';
import 'package:ai_mood_tracking_application/commons/profile_button_row.dart';
import 'package:ai_mood_tracking_application/commons/profile_data_row.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/services/message_service.dart';
import 'package:ai_mood_tracking_application/ui/counsellor/profile/profile_change_username_view.dart';
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
        padding: const EdgeInsets.all(0),
        child: Column(children: <Widget>[
          profilePictureContainer(userData, () {}), //TODO
          userDataContainer(userData),
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

  Widget profilePictureContainer(
      Map<String, dynamic> userData, VoidCallback onTap) {
    String imageUrl = 'assets/account_circle.png';
    if (userData["profilePicture"] != "" &&
        userData.containsKey("profilePicture")) {
      imageUrl = userData["profilePicture"];
    }

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ClipOval(
                clipper: ProfilePictureClipper(),
                child: Material(
                    color: Colors
                        .transparent, // Use transparent color for Material
                    child: InkWell(
                        onTap: onTap,
                        child: Image.asset(
                          imageUrl,
                          width: 150.0,
                          height: 150.0,
                        ))))),
        ProfileButton(title: "Change Profile Picture", onTap: onTap),
      ],
    );
  }

  Widget userDataContainer(Map<String, dynamic> userData) {
    return SizedBox(
        // 80% of screen width
        child: Column(children: <Widget>[
      ProfileDataRow(
        title: "Email",
        data: userData["email"],
        onTap: () => {}, //TODO
        subtitle: "",
      ),
      ProfileDataRow(
        title: "Username",
        subtitle: "Edit",
        data: userData["username"],
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileChangeUsernameView(
                        title: 'Edit Username',
                        defaultUsername: userData["username"],
                      )))
        },
      ),
      ProfileDataRow(
        title: "Password",
        subtitle: "Edit",
        data: "hidden",
        onTap: () => {}, //TODO
      ),
      ProfileDataRow(
        title: "Counselor Code",
        subtitle: "Copy to Clipboard",
        data: userData["counselorCode"],
        onTap: () => {}, //TODO
      ),
      ProfileButtonRow(title: "Share app now!", onTap: () => {} //TODO
          )
    ]));
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
