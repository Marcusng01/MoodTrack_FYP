import 'package:flutter/material.dart';

class ProfilePictureClipper extends CustomClipper<Rect> {
  late double size;

  ProfilePictureClipper(this.size);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, this.size, this.size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
