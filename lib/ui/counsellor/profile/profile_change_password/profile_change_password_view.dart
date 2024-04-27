import 'package:ai_mood_tracking_application/commons/profile_confirm_edit_dialog.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
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
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                changePasswordForm(
                    formKey,
                    oldPasswordTextEditingController,
                    newPasswordTextEditingController,
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
              ],
            )));
  }

  Widget changePasswordForm(
      GlobalKey<FormState> formKey,
      TextEditingController oldPasswordController,
      TextEditingController newPasswordController,
      TextEditingController confirmNewPasswordController) {
    return Form(
        key: formKey,
        child: Column(children: <Widget>[
          oldPasswordField(oldPasswordController),
          newPasswordField(newPasswordController),
          confirmNewPasswordField(
              newPasswordController, confirmNewPasswordController),
        ]));
  }

  Widget oldPasswordField(TextEditingController oldPasswordController) {
    return TextFormField(
      controller: oldPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Old Password',
        errorStyle: TextStyle(color: Colors.red),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your old password';
        }
        return null;
      },
    );
  }

  Widget newPasswordField(TextEditingController newPasswordController) {
    return TextFormField(
      controller: newPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'New Password',
        errorStyle: TextStyle(color: Colors.red),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your new password';
        }
        return null;
      },
    );
  }

  Widget confirmNewPasswordField(TextEditingController newPasswordController,
      TextEditingController confirmNewPasswordController) {
    return TextFormField(
      controller: confirmNewPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Confirm New Password',
        errorStyle: TextStyle(color: Colors.red),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your new password';
        }
        if (value != newPasswordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget doneButton() {
    return TextButton(
        child: const Text(
          "Done",
          style: AppTextStyles.mediumBlueText,
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            showDialog(
                context: context,
                builder: (context) => ProfileConfirmEditDialog(
                    title: "Edit Password?",
                    subtitle: "Are you sure you want to edit your password?.",
                    updateData: () {
                      Navigator.pop(context);
                      changePassword(oldPasswordTextEditingController.text,
                          newPasswordTextEditingController.text);
                    }));
          }
        });
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    // Show a loading dialog before starting the operation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Processing..."),
              ),
            ],
          ),
        );
      },
    );

    final user = _authService.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      // Dismiss the loading dialog after the operation is complete
      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Completed'),
            content: const Text(
                "Password Changed Successfully. Please Sign In Again."),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  AuthService().signOut();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Dismiss the loading dialog in case of an error
      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }
  }
}
