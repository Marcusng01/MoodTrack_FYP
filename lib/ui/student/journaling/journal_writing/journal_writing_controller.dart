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

  String generateFeelingSentence(List<String> moods) {
    // Remove duplicates from the list
    Set<String> uniqueMoods = moods.toSet();

    // If "neutral" is present along with other moods, remove it
    if (uniqueMoods.contains("neutral") && uniqueMoods.length > 1) {
      uniqueMoods.remove("neutral");
    }

    // Create the string
    String result = "felt ";
    result += uniqueMoods.join(', '); // Joining unique moods with commas

    // If there are more than one unique mood, add "and" before the last mood
    if (uniqueMoods.length > 1) {
      result = result.replaceRange(
        result.lastIndexOf(','),
        result.lastIndexOf(',') + 1,
        ' and',
      );
    }

    return result;
  }

  void sendJournalNotification(
      List<String> moods, String senderUserId, String receiverUserId) async {
    if (moods.isNotEmpty) {
      String message = generateFeelingSentence(moods);
      String token = await firestoreService.getUserFCMToken(receiverUserId);
      String username = await firestoreService.getUsername(senderUserId);
      // String imageUrl =
      //     await firestoreService.getUserProfilePicture(senderUserId);
      notificationService.sendNotification(token, username, message);
    }
  }
}
