import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.title});
  final String title;
  @override
  State<Register> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<Register> {
  final Auth _auth = Auth();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _counselorCodeController =
      TextEditingController();
  bool _isCounsellor = false;
  String _usernameLabel = 'Username';

  void _register(context) async {
    Map<String, dynamic> registerOutput =
        await _auth.createUserWithEmailAndPassword(
      email: _emailController,
      password: _passwordController,
      username: _usernameController,
      counselorCode: _counselorCodeController,
      isCounsellor: _isCounsellor,
    );
    if (registerOutput.containsKey('hash')) {
      // Navigate to RegisterSuccess screen
      Navigator.pushNamed(context, '/selectUserType/Register/Success',
          arguments: {
            'username': _usernameController.text,
            'counselorCode': registerOutput['hash'],
            'isCounsellor': _isCounsellor,
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

  @override
  Widget build(BuildContext context) {
    final userType = ModalRoute.of(context)!.settings.arguments as String?;
    if (userType == 'student') {
      _usernameLabel = 'Username (Student)';
      _isCounsellor = false;
    } else if (userType == 'counsellor') {
      _usernameLabel = 'Username (Counsellor)';
      _isCounsellor = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Registration Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _auth.entryField(_usernameLabel, _usernameController),
            _auth.entryField('Email', _emailController),
            _auth.entryField('Password', _passwordController, obscure: true),
            if (!_isCounsellor)
              _auth.entryField('Counselor Code', _counselorCodeController),
            ElevatedButton(
              onPressed: () => _register(context),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
