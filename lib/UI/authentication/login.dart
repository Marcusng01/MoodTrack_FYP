import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});
  final String title;
  @override
  State<Login> createState() => _MyLoginState();
}

class _MyLoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String? error;

  void _login(context) async {
    error = await Auth().signInWithEmailAndPassword(
      email: _controllerEmail,
      password: _controllerPassword,
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

  Widget _submitButton(context) {
    return ElevatedButton(
        onPressed: () => _login(context),
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
          Auth().entryField('email', _controllerEmail),
          Auth().entryField('password', _controllerPassword, obscure: true),
          Text(error == null ? '' : '$error'),
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
