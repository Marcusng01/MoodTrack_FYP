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
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Done",
                style: AppTextStyles.mediumBlueText,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: const Text('Edit Username?'),
                      content: const Text(
                          "Are you sure you want to edit your username?."),
                      actions: [
                        TextButton(
                            onPressed: () => {
                                  Navigator.of(context).pop(),
                                  _firestoreService.updateUsername(
                                      textEditingController.text),
                                  Navigator.pop(context)
                                },
                            child: const Text(
                              "Yes",
                              style: AppTextStyles.mediumBlueText,
                            )),
                        TextButton(
                            onPressed: () => {Navigator.of(context).pop()},
                            child: const Text(
                              "Cancel",
                              style: AppTextStyles.mediumGreyText,
                            ))
                      ]),
                );
              },
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: entryField("Username", textEditingController)),
                const Text(
                  "Modify your username so that other users are able to identify you.",
                  style: AppTextStyles.mediumGreyText,
                )
              ],
            )));
  }
}
