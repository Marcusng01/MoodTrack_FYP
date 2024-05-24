import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue,
            ),
            child: Text(
              message,
              style: AppTextStyles.smallWhiteText,
            )));
  }
}
