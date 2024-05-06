import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/message_service.dart';
import 'package:ai_mood_tracking_application/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageController {
  final TextEditingController messageInputController = TextEditingController();
  final MessageService messageService = MessageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthService auth = AuthService();
  final NotificationService notificationService = NotificationService();

  String getCurrentUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  void sendMessage(String receiverUserId) async {
    var message = messageInputController.text;
    if (message.isNotEmpty) {
      await messageService.sendMessage(receiverUserId, message);
      messageInputController.clear();
    }
  }

  void sendMessageWithNotification(String receiverUserId) async {
    var message = messageInputController.text;
    if (message.isNotEmpty) {
      await messageService.sendMessage(receiverUserId, message);
      messageInputController.clear();
      String token = await notificationService.getFCMToken();
      notificationService.sendNotification(token, message);
    }
  }
}
