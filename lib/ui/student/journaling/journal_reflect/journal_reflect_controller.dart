import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class JournalReflectController {
  final AuthService auth = AuthService();
  final FirestoreService firestoreService = FirestoreService();
  final PanelController panelController = PanelController();
  final TextEditingController newReflectionTextController =
      TextEditingController();
  bool isFabVisible = true;
  DateTime date = DateTime.now();
  late DocumentSnapshot doc;
}
