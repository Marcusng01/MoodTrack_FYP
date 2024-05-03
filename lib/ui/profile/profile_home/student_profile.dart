import 'dart:io';

import 'package:ai_mood_tracking_application/commons/profile_button.dart';
import 'package:ai_mood_tracking_application/commons/profile_button_row.dart';
import 'package:ai_mood_tracking_application/commons/profile_data_row.dart';
import 'package:ai_mood_tracking_application/commons/profile_picture_clipper.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/services/storage_service.dart';
import 'package:ai_mood_tracking_application/ui/profile/profile_change_password/profile_change_password_view.dart';
import 'package:ai_mood_tracking_application/ui/profile/profile_change_username/profile_change_username_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class StudentProfile extends StatefulWidget {
  final String counsellorUsername;
  final String counsellorUserId;
  StudentProfile({
    super.key,
    required this.counsellorUsername,
    required this.counsellorUserId,
  });
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<StudentProfile> createState() => _MyStudentProfileState();
}

class _MyStudentProfileState extends State<StudentProfile> {
  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.streamUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return studentProfileLoadingScreen();
          }
          Map<String, dynamic> userData = snapshot.data!.docs.first.data();
          return studentProfileScreen(userData);
        });
  }

  Widget studentProfileScreen(Map<String, dynamic> userData) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(children: <Widget>[
          profilePictureContainer(userData, () {
            _pickImageFromGallery();
          }),
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
    Image image = Image.asset(
      'assets/account_circle.png',
      width: 150.0,
      height: 150.0,
    );
    if (userData["profilePicture"] != "" &&
        userData.containsKey("profilePicture")) {
      image = Image.network(
        userData["profilePicture"],
        width: 150.0,
        height: 150.0,
      );
    }

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ClipOval(
                clipper: ProfilePictureClipper(150),
                child: Material(
                    color: Colors
                        .transparent, // Use transparent color for Material
                    child: InkWell(onTap: onTap, child: image)))),
        ProfileButton(title: "Change Profile Picture", onTap: onTap),
      ],
    );
  }

  Widget userDataContainer(Map<String, dynamic> userData) {
    SnackBar snackBar = const SnackBar(
      content: Text("Copied to Clipboard"),
    );
    return SizedBox(
        // 80% of screen width
        child: Column(children: <Widget>[
      ProfileDataRow(
        title: "Email",
        data: userData["email"],
        onTap: () => {},
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
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileChangePasswordView(
                        title: 'Edit Password',
                      )))
        },
      ),
      ProfileDataRow(
        title: "${widget.counsellorUsername}'s Counsellor Code",
        subtitle: "Copy to Clipboard",
        data: userData["counselorCode"],
        onTap: () => {
          Clipboard.setData(ClipboardData(text: userData["counselorCode"])),
          ScaffoldMessenger.of(context).showSnackBar(snackBar),
        },
      ),
      ProfileButtonRow(
          title: "Share app now!",
          onTap: () async {
            Share.share(
                "Download MoodTrack now at:\nhttps://github.com/Marcusng01/MoodTrack_FYP\n\nFor Students:\nRegister using counselor code ${userData["counselorCode"]} to begin your healing journey with ${widget.counsellorUsername}\n\nFor Counselors:\nRegister your account, then share your counselor code with your students.");
          })
    ]));
  }

  Widget studentProfileLoadingScreen() {
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

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    await _storage.uploadImage(File(returnedImage.path));
    _firestore.updateProfilePictureUrl(_storage.imageUrl);
  }
}
