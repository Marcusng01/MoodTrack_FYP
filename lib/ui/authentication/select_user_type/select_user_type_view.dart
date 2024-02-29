import 'package:ai_mood_tracking_application/ui/authentication/select_user_type/select_user_type_controller.dart';
import 'package:flutter/material.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({super.key, required this.title});
  final String title;
  @override
  State<SelectUserType> createState() => _MySelectUserTypeState();
}

class _MySelectUserTypeState extends State<SelectUserType> {
  SelectUserTypeController controller = SelectUserTypeController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Type')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.navigateToRegisterView(context, "student");
              },
              child: const Text('Register as Student'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.navigateToRegisterView(context, "counsellor");
              },
              child: const Text('Register as Counsellor'),
            ),
          ],
        ),
      ),
    );
  }
}
