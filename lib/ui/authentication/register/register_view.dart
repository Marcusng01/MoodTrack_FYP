import 'package:ai_mood_tracking_application/commons/text_field.dart';
import 'package:ai_mood_tracking_application/ui/authentication/register/register_controller.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, required this.title});
  final String title;
  @override
  State<RegisterView> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<RegisterView> {
  final RegisterController controller = RegisterController();
  @override
  Widget build(BuildContext context) {
    final userType = ModalRoute.of(context)!.settings.arguments as String?;
    if (userType == 'student') {
      controller.usernameLabel = 'Username (Student)';
      controller.isCounsellor = false;
    } else if (userType == 'counsellor') {
      controller.usernameLabel = 'Username (Counsellor)';
      controller.isCounsellor = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Registration Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            entryField(controller.usernameLabel, controller.usernameController),
            entryField('Email', controller.emailController),
            entryField('Password', controller.passwordController,
                obscure: true),
            if (!controller.isCounsellor)
              entryField('Counselor Code', controller.counselorCodeController),
            ElevatedButton(
              onPressed: () => controller.register(context),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
