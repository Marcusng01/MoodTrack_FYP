import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JournalResultController {
  final ScrollController scrollController = ScrollController();
  FirestoreService fireStoreService = FirestoreService();
  String selectedRating = "unsure";
  late DateTime date;
  late DocumentSnapshot doc;
  String text = "";
}
