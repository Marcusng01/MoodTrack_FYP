import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:flutter/material.dart';

class ChatTrailingIcon extends StatelessWidget {
  final bool unread;
  final bool isSender;

  ChatTrailingIcon({required this.unread, required this.isSender});

  @override
  Widget build(BuildContext context) {
    double size = 20.0;
    if (unread && isSender) {
      return Icon(
        Icons.check,
        size: size,
        color: AppColors.greyText,
      );
    } else if (!unread && isSender) {
      return const Stack(
        children: <Widget>[
          Icon(Icons.check, color: AppColors.blueSurface),
          Positioned(
            left: 5,
            top: 1,
            child: Icon(Icons.check, color: AppColors.blueSurface),
          ),
        ],
      );
    } else if (unread && !isSender) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blueSurface,
        ),
      );
    } else if (!unread && !isSender) {
      return SizedBox(width: size, height: size);
    }
    return SizedBox(width: size, height: size);
  }
}
