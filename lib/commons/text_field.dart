import 'package:flutter/material.dart';

Widget entryField(String title, TextEditingController controller,
    {bool obscure = false}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: title),
    obscureText: obscure,
  );
}
