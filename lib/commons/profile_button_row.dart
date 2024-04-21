import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileButtonRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const ProfileButtonRow({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          children: [
            const Divider(
              color: AppColors.lightBlueSurface,
              height: 3,
              thickness: 3,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  title,
                  style: AppTextStyles.mediumBlueText,
                )
              ]),
            )
          ],
        ));
  }
}
