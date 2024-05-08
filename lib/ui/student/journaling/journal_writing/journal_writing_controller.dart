import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/services/notification_service.dart';
import 'package:flutter/material.dart';

class JournalWritingController {
  final ScrollController scrollController = ScrollController();
  FirestoreService firestoreService = FirestoreService();
  AuthService auth = AuthService();
  TextEditingController journalInputController = TextEditingController();
  String selectedRating = "unsure";
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String placeholder = "";
  bool modifyPlaceholder = true;
  final NotificationService notificationService = NotificationService();

  void sendJournalNotification(
      List<String> moods, String senderUserId, String receiverUserId) async {
    if (moods.isNotEmpty) {
      String message = moods.toString();
      String token = await firestoreService.getUserFCMToken(receiverUserId);
      String username = await firestoreService.getUsername(senderUserId);
      // String imageUrl =
      //     await firestoreService.getUserProfilePicture(senderUserId);
      notificationService.sendNotification(token, username, message);
    }
  }
}
