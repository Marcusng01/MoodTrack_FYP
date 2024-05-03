import 'package:ai_mood_tracking_application/commons/profile_picture.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:ai_mood_tracking_application/ui/student/analyse/analyse_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyseListItem extends StatelessWidget {
  final Map<String, dynamic> counselorData;
  final Map<String, dynamic> studentData;
  final FirestoreService firestoreService;
  const AnalyseListItem({
    super.key,
    required this.counselorData,
    required this.studentData,
    required this.firestoreService,
  });

  @override
  Widget build(BuildContext context) {
    String username = studentData['username'];
    return StreamBuilder(
        stream: firestoreService.streamJournals(studentData["id"]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Card(
              child: ListTile(
                tileColor: AppColors.greySurface,
                leading: Icon(Icons.person),
                title: Text("Loading...",
                    style: AppTextStyles.mediumGreyText,
                    overflow: TextOverflow.ellipsis),
              ),
            );
          }
          Map<String, dynamic> lastJournalData = snapshot.data!.docs.isNotEmpty
              ? snapshot.data!.docs.last.data()
              : {};
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnalyseView(
                            username: studentData["username"],
                            userId: studentData["id"])));
              },
              child: Card(
                child: ListTile(
                  leading: ProfilePicture(userData: studentData, size: 50),
                  title: analyseListItemTitle(username, lastJournalData),
                  subtitle: analyseListItemSubtitle(username, lastJournalData),
                ),
              ));
        });
  }

  Widget analyseListItemTitle(
      String username, Map<String, dynamic> lastJournalData) {
    String timeString = lastJournalData.isNotEmpty
        ? journalTimestampToString(lastJournalData["date"])
        : "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          username,
          style: AppTextStyles.largeBlackText,
        ),
        Text(
          timeString,
          style: AppTextStyles.mediumGreyText,
        ),
      ],
    );
  }

  String journalTimestampToString(Timestamp time) {
    // Convert Timestamp to DateTime
    DateTime dateTime = time.toDate();

    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the difference in days between the current date and the provided date
    int daysDifference = now.difference(dateTime).inDays;

    // Format the date based on the conditions
    if (daysDifference == 0) {
      // If the date is today, return the time of day in format HH:MM am/pm
      return "Today";
    } else if (daysDifference == 1) {
      // If the date is yesterday, return the string "Yesterday"
      return "Yesterday";
    } else if (daysDifference <= 7) {
      // If the date is within a week ago, return the Day of Week
      return DateFormat('EEEE').format(dateTime);
    } else {
      // If older, return the time in DD/MM/YYYY format
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  String highestMood(Map<String, dynamic> journalData) {
    if (journalData.isEmpty) {
      return "";
    }
    var count = {};
    for (var mood in journalData['mood']) {
      if (mood != "neutral") {
        count.update(
          mood,
          (existingValue) =>
              existingValue is double ? existingValue + 1.0 : 1.0,
          ifAbsent: () => 1.0,
        );
      }
    }
    String highestValueMood = "";
    double highestValue = double.negativeInfinity;

    count.forEach((key, value) {
      if (value > highestValue) {
        highestValue = value;
        highestValueMood = key;
      }
    });
    return highestValueMood;
  }

  Widget analyseListItemSubtitle(
      String username, Map<String, dynamic> lastJournalData) {
    String subtitleText;
    Color color;
    if (lastJournalData.isEmpty) {
      subtitleText = "$username has no journals.";
      color = AppColors.greySurface;
    } else {
      String mood = highestMood(lastJournalData);
      subtitleText = "$username felt ${highestMood(lastJournalData)}";
      color = AppColors.getColorForEmotion(mood, AppColors.greySurface);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(subtitleText,
            style: AppTextStyles.mediumGreyText,
            overflow: TextOverflow.ellipsis),
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        )
      ],
    );
  }
}
