import 'package:ai_mood_tracking_application/commons/text_field.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:ai_mood_tracking_application/ui/authentication/login/login_controller.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.title});
  final String title;
  @override
  State<LoginView> createState() => _MyLoginState();
}

class _MyLoginState extends State<LoginView> {
  final LoginController controller = LoginController();

  Widget _submitButton(context) {
    return ElevatedButton(
        onPressed: () => controller.login(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blueSurface,
          textStyle: AppTextStyles.smallWhiteText,
        ),
        child: const Text(
          "Log in",
          style: AppTextStyles.smallWhiteText,
        ));
  }

  Widget _body(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'AI Mood Tracker',
            style: AppTextStyles.largeBoldBlackText,
          ),
          Image.asset(
            'assets/logo.png',
            width: 150.0,
            height: 150.0,
          ),
          entryField('email', controller.emailController),
          entryField('password', controller.passwordController, obscure: true),
          Text(controller.error == null ? '' : '$controller.error'),
          _submitButton(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/selectUserType');
        },
        label: const Text("Register Here"),
      ),
    );
  }
}
