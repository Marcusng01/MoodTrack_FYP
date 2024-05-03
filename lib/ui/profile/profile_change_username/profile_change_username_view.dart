import 'package:ai_mood_tracking_application/commons/profile_confirm_edit_dialog.dart';
import 'package:ai_mood_tracking_application/commons/text_field.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileChangeUsernameView extends StatefulWidget {
  final String defaultUsername;
  final String title;
  ProfileChangeUsernameView(
      {super.key, required this.title, required this.defaultUsername});
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<ProfileChangeUsernameView> createState() => _MyCounsellorProfileState();
}

class _MyCounsellorProfileState extends State<ProfileChangeUsernameView> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget.defaultUsername;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[doneButton()],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                entryField("Username", textEditingController),
                const SizedBox(height: 10),
                const Text(
                  "Modify your username so that other users are able to identify you.",
                  style: AppTextStyles.mediumGreyText,
                )
              ],
            )));
  }

  Widget doneButton() {
    return TextButton(
        child: const Text(
          "Done",
          style: AppTextStyles.mediumBlueText,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => ProfileConfirmEditDialog(
                  title: "Edit Username?",
                  subtitle: "Are you sure you want to edit your username?.",
                  updateData: () {
                    Navigator.of(context).pop();
                    _firestoreService
                        .updateUsername(textEditingController.text);
                    Navigator.pop(context);
                  }));
        });
  }
}
