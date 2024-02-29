import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterController {
  final AuthService authService = AuthService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController counselorCodeController = TextEditingController();
  bool isCounsellor = false;
  String usernameLabel = 'Username';

  void register(context) async {
    Map<String, dynamic> registerOutput =
        await authService.createUserWithEmailAndPassword(
      email: emailController,
      password: passwordController,
      username: usernameController,
      counselorCode: counselorCodeController,
      isCounsellor: isCounsellor,
    );
    if (registerOutput.containsKey('hash')) {
      // Navigate to RegisterSuccess screen
      Navigator.pushNamed(context, '/selectUserType/Register/Success',
          arguments: {
            'username': usernameController.text,
            'counselorCode': registerOutput['hash'],
            'isCounsellor': isCounsellor,
          });
    } else if (registerOutput.containsKey('error')) {
      // Display error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(registerOutput['error']),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text("Something went wrong."),
        ),
      );
    }
  }
}
