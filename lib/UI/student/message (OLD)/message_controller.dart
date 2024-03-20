import 'package:ai_mood_tracking_application/services/message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageController {
  final TextEditingController messageInputController = TextEditingController();
  final MessageService messageService = MessageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
}
