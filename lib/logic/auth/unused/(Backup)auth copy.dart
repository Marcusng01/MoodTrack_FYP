import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  Future<String?> createUserWithEmailAndPassword({
    required TextEditingController email,
    required TextEditingController password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Widget entryField(String title, TextEditingController controller,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: title),
      obscureText: obscure,
    );
  }
}
