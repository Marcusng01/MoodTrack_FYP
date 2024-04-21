import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const ProfileButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
            onPressed: onTap,
            child: Text(
              title,
              style: AppTextStyles.mediumBlueText,
            ))
      ]),
    );
  }
}
