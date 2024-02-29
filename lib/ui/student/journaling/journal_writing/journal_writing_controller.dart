import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:flutter/material.dart';

class JournalWritingController {
  final ScrollController scrollController = ScrollController();
  FirestoreService fireStoreService = FirestoreService();
  TextEditingController journalInputController = TextEditingController();
  String selectedRating = "unsure";
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String placeholder = "";
  bool modifyPlaceholder = true;
}
