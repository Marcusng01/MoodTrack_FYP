import 'package:ai_mood_tracking_application/commons/chat_trailing_icon.dart';
import 'package:ai_mood_tracking_application/services/message_service.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:ai_mood_tracking_application/ui/student/message%20(OLD)/message_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageListItem extends StatelessWidget {
  final Map<String, dynamic> counselorData;
  final Map<String, dynamic> studentData;
  final MessageService messageService;
  const MessageListItem({
    super.key,
    required this.counselorData,
    required this.studentData,
    required this.messageService,
  });

  @override
  Widget build(BuildContext context) {
    String username = studentData['username'];
    return StreamBuilder(
        stream: messageService.getLatestMessage(
            counselorData["id"], studentData["id"]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("Loading...",
                    style: AppTextStyles.mediumGreyText,
                    overflow: TextOverflow.ellipsis),
              ),
            );
          }

          Map<String, dynamic> latestMessageData =
              snapshot.data!.docs.isNotEmpty
                  ? snapshot.data!.docs.first.data()
                  : {};
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessageView(
                            receiverUsername: studentData["username"],
                            receiverUserId: studentData["id"])));
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: messageListItemTitle(username, latestMessageData),
                  subtitle: messageListItemSubtitle(
                      counselorData, studentData, latestMessageData),
                ),
              ));
        });
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

  Widget messageListItemSubtitle(
      Map<String, dynamic> counselorData,
      Map<String, dynamic> studentData,
      Map<String, dynamic> latestMessageData) {
    if (latestMessageData.isEmpty) {
      return const Text("No Messages.",
          style: AppTextStyles.mediumGreyText, overflow: TextOverflow.ellipsis);
    } else {
      bool isSender = latestMessageData["senderId"] == counselorData["id"];
      String message = isSender
          ? "You: ${latestMessageData['message']}"
          : latestMessageData['message'];
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message,
              style: AppTextStyles.mediumGreyText,
              overflow: TextOverflow.ellipsis),
          ChatTrailingIcon(
              unread: latestMessageData["unread"], isSender: isSender),
        ],
      );
    }
  }
}
