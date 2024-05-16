import 'package:ai_mood_tracking_application/services/message_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:ai_mood_tracking_application/ui/student/message%20(OLD)/message_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageStudentDashboardButton extends StatelessWidget {
  final Map<String, dynamic> counselorData;
  final Map<String, dynamic> studentData;
  final MessageService messageService;
  final IconData icon;
  const MessageStudentDashboardButton({
    super.key,
    required this.counselorData,
    required this.studentData,
    required this.messageService,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: messageService.getLatestMessage(
            counselorData["id"], studentData["id"]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Card(
              child: ElevatedButton(
                onPressed: () => {},
                child: const Text("Loading...",
                    style: AppTextStyles.mediumGreyText,
                    overflow: TextOverflow.ellipsis),
              ),
            );
          }

          Map<String, dynamic> latestMessageData =
              snapshot.data!.docs.isNotEmpty
                  ? snapshot.data!.docs.first.data()
                  : {};
          return ElevatedButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessageView(
                            receiverData: counselorData,
                          )))
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  dashboadButtonText(
                      "Message Counsellor",
                      messageListItemSubtitle(
                          counselorData, studentData, latestMessageData),
                      messageTimestampToString(latestMessageData["timestamp"])),
                  dashboardButtonIcon(icon)
                ],
              ),
            ),
          );
        });
  }

  Widget dashboardButtonIcon(icon) {
    return Icon(
      icon,
      color: AppColors.blueSurface,
      size: 45,
    );
  }

  Widget dashboadButtonText(head, body, foot) {
    return SizedBox(
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(head,
              style: AppTextStyles.largeBlueText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          Text(body,
              style: AppTextStyles.mediumBlackText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          Text(foot,
              style: AppTextStyles.mediumGreyText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget messageListItemTitle(
      String username, Map<String, dynamic> latestMessageData) {
    String timeString = latestMessageData.isNotEmpty
        ? messageTimestampToString(latestMessageData["timestamp"])
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

  String messageTimestampToString(Timestamp time) {
    // Convert Timestamp to DateTime
    DateTime dateTime = time.toDate();

    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the difference in days between the current date and the provided date
    int daysDifference = now.difference(dateTime).inDays;

    // Format the date based on the conditions
    if (daysDifference == 0) {
      // If the date is today, return the time of day in format HH:MM am/pm
      return DateFormat('h:mm a').format(dateTime);
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

  String messageListItemSubtitle(
      Map<String, dynamic> counselorData,
      Map<String, dynamic> studentData,
      Map<String, dynamic> latestMessageData) {
    if (latestMessageData.isEmpty) {
      return "No Messages.";
    } else {
      bool isSender = latestMessageData["senderId"] == counselorData["id"];
      String message = isSender
          ? "You: ${latestMessageData['message']}"
          : latestMessageData['message'];
      return message;
    }
  }
}
