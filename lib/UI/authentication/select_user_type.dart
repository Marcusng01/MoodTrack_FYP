import 'package:flutter/material.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({super.key, required this.title});
  final String title;
  @override
  State<SelectUserType> createState() => _MySelectUserTypeState();
}

// class _MySelectUserTypeState extends State<SelectUserType> {
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
//               'SelectUserType',
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.pushNamed(context, '/selectUserType/Register');
//         },
//         label: const Text("Register"),
//       ),
//     );
//   }
// }

class _MySelectUserTypeState extends State<SelectUserType> {
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
                Navigator.pushNamed(context, '/selectUserType/Register',
                    arguments: 'student');
              },
              child: const Text('Register as Student'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/selectUserType/Register',
                    arguments: 'counsellor');
              },
              child: const Text('Register as Counsellor'),
            ),
          ],
        ),
      ),
    );
  }
}
