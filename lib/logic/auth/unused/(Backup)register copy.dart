import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.title});
  final String title;
  @override
  State<Register> createState() => _MyRegisterState();
}

// class _MyRegisterState extends State<Register> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Register',
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.of(context).pushNamedAndRemoveUntil(
//             '/selectUserType/Register/Success',
//             (Route<dynamic> route) => false,
//           );
//         },
//         label: const Text("Register"),
//       ),
//     );
//   }
// }

class _MyRegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    final userType = ModalRoute.of(context)!.settings.arguments as String?;
    // Implement registration details UI based on userType (student or counsellor)
    // Use forms to capture username, email, password, and counsellor code
    // Once registered, display registration details accordingly

    // Example:
    String usernameLabel = 'Username';
    String emailLabel = 'Email';
    String passwordLabel = 'Password';
    String counselorCodeLabel = 'Counselor Code';

    if (userType == 'student') {
      usernameLabel = 'Username (Student)';
      // ...
    } else if (userType == 'counsellor') {
      usernameLabel = 'Username (Counsellor)';
      // ...
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Registration Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Enter your $usernameLabel, $emailLabel, $passwordLabel, $counselorCodeLabel'),
            // Implement form fields and registration logic here
          ],
        ),
      ),
    );
  }
}
