import 'dart:convert';

import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/logic/journaling/sentiment_analysis_flask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WritingController {
  final Auth _auth = Auth();
  User? get currentUser => _auth.currentUser;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
