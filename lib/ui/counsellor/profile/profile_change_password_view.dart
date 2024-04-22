import 'package:ai_mood_tracking_application/commons/profile_confirm_edit_dialog.dart';
import 'package:ai_mood_tracking_application/commons/text_field.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileChangePasswordView extends StatefulWidget {
  final String title;
  ProfileChangePasswordView({super.key, required this.title});
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<ProfileChangePasswordView> createState() => _MyCounsellorProfileState();
}

class _MyCounsellorProfileState extends State<ProfileChangePasswordView> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController oldPasswordTextEditingController =
      TextEditingController();
  final TextEditingController newPasswordTextEditingController =
      TextEditingController();
  final TextEditingController confirmNewPasswordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    oldPasswordTextEditingController.text = "";
    newPasswordTextEditingController.text = "";
    confirmNewPasswordTextEditingController.text = "";
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: <Widget>[doneButton()],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                entryField("Old Password", oldPasswordTextEditingController),
                const SizedBox(height: 10),
                entryField("New Password", newPasswordTextEditingController),
                const SizedBox(height: 10),
                entryField("Confirm Password",
                    confirmNewPasswordTextEditingController),
                const SizedBox(height: 10),
                const Text(
                  "To ensure that your password is safe, it should have:",
                  style: AppTextStyles.mediumGreyText,
                ),
                const SizedBox(height: 5),
                const Text(
                  "A minimum length of 6 characters.",
                  style: AppTextStyles.smallGreyText,
                ),
                const SizedBox(height: 5),
                const Text(
                  "At least one uppercase letter.",
                  style: AppTextStyles.smallGreyText,
                ),
                const SizedBox(height: 5),
                const Text(
                  "At least one lowercase letter.",
                  style: AppTextStyles.smallGreyText,
                ),
                const SizedBox(height: 5),
                const Text(
                  "At least one digit.",
                  style: AppTextStyles.smallGreyText,
                ),
                const SizedBox(height: 5),
                const Text(
                  "At least one special character.",
                  style: AppTextStyles.smallGreyText,
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
                  title: "Edit Password?",
                  subtitle: "Are you sure you want to edit your password?.",
                  updateData: () {
                    // _firestoreService
                    //     .updatePassword(textEditingController.text);
                  }));
        });
  }
}
