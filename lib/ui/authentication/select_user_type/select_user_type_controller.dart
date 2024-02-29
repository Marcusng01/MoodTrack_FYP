import 'package:flutter/material.dart';

class SelectUserTypeController {
  void navigateToRegisterView(BuildContext context, String userType) {
    Navigator.pushNamed(context, '/selectUserType/Register',
        arguments: userType);
  }
}
