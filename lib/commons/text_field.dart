import 'package:flutter/material.dart';

Widget entryField(String title, TextEditingController controller,
    {bool obscure = false}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: title,
      suffixIcon: controller.text.isEmpty
          ? null
          : IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => controller.clear(),
            ),
    ),
    obscureText: obscure,
  );
}
