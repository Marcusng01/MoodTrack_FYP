import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signInWithEmailAndPassword({
    required TextEditingController email,
    required TextEditingController password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  String generateRandomHash(String userUid) {
    // Create a hash combining the user's UID and current timestamp
    var bytes = utf8.encode('$userUid${DateTime.now().millisecondsSinceEpoch}');
    var hash = sha256.convert(bytes);

    // Take a part of the hash as the referral code
    return hash
        .toString()
        .substring(0, 8); // You can adjust the length as needed
  }

  Future<Map<String, dynamic>> createUserWithEmailAndPassword({
    required TextEditingController email,
    required TextEditingController password,
    required TextEditingController username,
    required bool isCounsellor,
    required TextEditingController counselorCode,
  }) async {
    Map<String, dynamic> dict = {};
    // For Students: Check if the counselor code exists in Firestore
    if (username.text == "") {
      dict['error'] = "Please enter a username.";
      return dict;
    } else if (email.text == "") {
      dict['error'] = "Please enter an email.";
      return dict;
    } else if (password.text == "") {
      dict['error'] = "Please enter a password.";
      return dict;
    } else if (!isCounsellor) {
      try {
        await correspondingCounsellor(counselorCode.text);
      } catch (e) {
        dict['error'] = "Couldn't find counsellor.";
        return dict;
      }
    }

    //For all: Try to register using email and password
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // For students: Use counselorCode input
      // For counsellors: Generate counselorCode
      String counselorCodeHash = isCounsellor
          ? generateRandomHash(userCredential.user!.uid)
          : counselorCode.text;

      // For all: store user details in Firestore
      await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username.text,
        'isCounsellor': isCounsellor,
        'counselorCode': counselorCodeHash,
      });
      dict['hash'] = counselorCodeHash;
      return dict;
    } on FirebaseAuthException catch (e) {
      dict['error'] = e.message;
      return dict;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<DocumentSnapshot> correspondingCounsellor(String counselorCode) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('/users')
        .where('counselorCode', isEqualTo: counselorCode)
        .where('isCounsellor', isEqualTo: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('No counsellor found with the given code');
    }

    return querySnapshot.docs[0];
  }

  Future<DocumentSnapshot> getUserDetails() async {
    CollectionReference users = _firebaseFirestore.collection('users');
    return users.doc(currentUser!.uid).get();
  }
}
