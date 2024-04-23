import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileConfirmEditDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback updateData;
  const ProfileConfirmEditDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.updateData,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text(title), content: Text(subtitle), actions: [
      TextButton(
          onPressed: () {
            updateData();
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
    ]);
  }
}
