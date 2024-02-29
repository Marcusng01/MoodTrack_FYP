import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? error;
  final AuthService authService = AuthService();

  void login(context) async {
    error = await authService.signInWithEmailAndPassword(
      email: emailController,
      password: passwordController,
    );
    if (error != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error!),
        ),
      );
    }
  }
}
