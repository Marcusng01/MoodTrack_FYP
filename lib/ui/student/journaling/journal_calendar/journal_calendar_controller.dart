import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:flutter/material.dart';

class JournalCalendarController {
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  ValueNotifier<DateTime> reflectButtonNofitier = ValueNotifier<DateTime>(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  Map<DateTime, String> events = {};
  FirestoreService fireStoreService = FirestoreService();

  Color dateColor(date) {
    Color color = AppColors().ratingColor(events[date]);
    return color;
  }

  TextStyle dateTextStyle(date) {
    TextStyle textStyle = AppTextStyles().ratingTextStyle(events[date]);
    return textStyle;
  }

  void navigateToReflect(BuildContext context) {
    Navigator.pushNamed(context, '/Student/Journaling/Reflect', arguments: {
      "date": selectedDay,
    });
  }
}
