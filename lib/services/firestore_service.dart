import 'dart:convert';
import 'dart:core';

import 'package:ai_mood_tracking_application/data/reminder_item.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FirestoreService {
  final AuthService _auth = AuthService();
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

  //Submit Document
  Future<void> storeJournal(TextEditingController journalInputController,
      DateTime date, String rating) async {
    String dateString = date.toString();
    List<String> sentences =
        journalInputController.text.split(RegExp(r'(?<=[.!?])\s+'));
    List<String> moods = [];
    for (var sentence in sentences) {
      String jsonString =
          //emulators use 10.0.2.2:5000 instead of 127.0.0.1:5000. Change this to a URL online
          await fetchdata(
              "https://flask-huggingface.azurewebsites.net/hug?sentence=$sentence");
      var jsonMoods = jsonDecode(jsonString);
      String mood =
          jsonMoods[0][0]['score'] > 0.4 ? jsonMoods[0][0]['label'] : "neutral";
      // jsonMoods[0][0]['label'];
      moods.add(mood);
    }

    try {
      // For all: store user details in Firestore
      await _firebaseFirestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('journals')
          .doc(dateString)
          .set({
        'date': date,
        'journal': journalInputController.text,
        'sentences': sentences,
        'rating': rating,
        'mood': moods
      }, SetOptions(merge: true));
      Fluttertoast.showToast(
        msg: "Journal Submitted Successfully",
      );
    } on Exception {
      Fluttertoast.showToast(
        msg: "Journal Could Not Be Submitted",
      );
    }
  }

  // Retrieve Journal
  Future<QuerySnapshot<Map<String, dynamic>>> getJournals() async {
    var querySnapshot = await _firebaseFirestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('journals')
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception("User doesn't have any journals.");
    } else {
      return querySnapshot;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamJournals(String? id) {
    return _firebaseFirestore
        .collection('users')
        .doc(id)
        .collection('journals')
        .snapshots();
  }

  Future<DocumentSnapshot> getJournalByDate(DateTime date) async {
    var formattedDate = date.toString(); // Convert DateTime to string
    var docRef = _firebaseFirestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('journals')
        .doc(formattedDate)
        .get();
    var docSnapshot = await docRef;
    if (!docSnapshot.exists) {
      throw Exception('No journal found for the given date');
    } else {
      return docSnapshot;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getJournalByDateStream(
      date) async* {
    var formattedDate = date.toString(); // Convert DateTime to string
    var docRef = _firebaseFirestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('journals')
        .doc(formattedDate)
        .snapshots();
    await for (var docSnapshot in docRef) {
      if (!docSnapshot.exists) {
        throw Exception('No journal found for the given date');
      } else {
        yield docSnapshot;
      }
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getJournalsStream() {
    return _firebaseFirestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('journals')
        .snapshots();
  }

  Stream<Map<DateTime, String>> getDateTimeRatingMapAsStream() {
    return getJournalsStream().map((querySnapshot) {
      Map<DateTime, String> dateTimeRatingMap = {};
      for (var doc in querySnapshot.docs) {
        DateTime date = doc['date'].toDate();
        String rating = doc['rating'];
        dateTimeRatingMap[date] = rating;
      }
      return dateTimeRatingMap;
    });
  }
}

fetchdata(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}
