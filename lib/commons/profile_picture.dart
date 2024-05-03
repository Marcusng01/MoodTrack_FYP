import 'package:ai_mood_tracking_application/commons/profile_picture_clipper.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final Map<String, dynamic> userData;
  final double size;
  const ProfilePicture({
    super.key,
    required this.userData,
    required this.size,
  });
  @override
  Widget build(BuildContext context) {
    Image image = Image.asset(
      'assets/account_circle.png',
      width: size,
      height: size,
    );
    if (userData["profilePicture"] != "" &&
        userData.containsKey("profilePicture")) {
      image = Image.network(
        userData["profilePicture"],
        width: size,
        height: size,
      );
    }

    return ClipOval(
      clipper: ProfilePictureClipper(size),
      child: Material(
          color: Colors.transparent, // Use transparent color for Material
          child: image),
    );
  }
}
