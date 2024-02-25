import 'dart:core';

import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReflectingController {
  final Auth _auth = Auth();
  User? get currentUser => _auth.currentUser;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  DocumentReference getJournalReferencebyDate(DateTime date) {
    var formattedDate = date.toString();
    final CollectionReference users = _firebaseFirestore.collection('users');
    final DocumentReference user = users.doc(currentUser?.uid);
    final CollectionReference journals = user.collection('journals');
    return journals.doc(formattedDate);
  }

  void createOrUpdateReflection(DateTime date, String reflection) {
    final DocumentReference journal = getJournalReferencebyDate(date);
    journal.set({
      'reflections': FieldValue.arrayUnion([reflection])
    }, SetOptions(merge: true));
  }

  void deleteReflection(DateTime date, String reflection) {
    final DocumentReference journal = getJournalReferencebyDate(date);
    journal.update({
      'reflections': FieldValue.arrayRemove([reflection])
    });
  }

  List<ReminderItem> createReminderItemsFromQuerySnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<ReminderItem> list = [];
    for (var doc in snapshot.docs) {
      try {
        // Get the 'reflections' field
        List<dynamic> reflectionsDynamic = doc["reflections"];
        List<String> reflections = reflectionsDynamic.cast<String>();
        if (reflections.isEmpty) {
          throw Exception();
        }

        // Get the DateTime from ID
        String id = doc.id;
        DateTime dateTime = DateTime.parse(id);

        // Add to the dictionary
        ReminderItem reminderItem = ReminderItem(
          headerValue: dateTime,
          expandedValues: reflections,
        );
        list.add(reminderItem);
      } catch (e) {
        continue;
      }
    }
    return list;
  }
}

class ReminderItem {
  ReminderItem({
    required this.expandedValues,
    required this.headerValue,
  });

  DateTime headerValue;
  List<String> expandedValues;
}
