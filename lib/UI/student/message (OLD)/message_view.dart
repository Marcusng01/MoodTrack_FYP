import 'package:ai_mood_tracking_application/commons/chat_bubble.dart';
import 'package:ai_mood_tracking_application/commons/profile_picture.dart';
import 'package:ai_mood_tracking_application/commons/text_field.dart';
import 'package:ai_mood_tracking_application/ui/student/message%20(OLD)/message_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageView extends StatefulWidget {
  final Map<String, dynamic> receiverData;
  const MessageView({
    super.key,
    required this.receiverData,
  });
  @override
  State<MessageView> createState() => _MyMessageViewState();
}

class _MyMessageViewState extends State<MessageView> {
  final MessageController _controller = MessageController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _controller.messageService.setMultipleMessageAsRead(
            _controller.getCurrentUserId(), widget.receiverData["id"]),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Row(children: [
                ProfilePicture(userData: widget.receiverData, size: 30),
                const SizedBox(width: 10),
                Text(widget.receiverData["username"]),
              ]),
            ),
            body: Column(
              children: [
                Expanded(
                  child: _buildMessageList(),
                ),
                _buildMessageInput()
              ],
            ),
          );
        });
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _controller.messageService.getMessages(
            widget.receiverData["id"], _controller.getCurrentUserId()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          return ListView(
              children: snapshot.data!.docs
                  .map((document) => _buildMessageItem(document))
                  .toList());
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _controller.getCurrentUserId())
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
                (data['senderId'] == _controller.auth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == _controller.auth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              ChatBubble(message: data['message']),
            ],
          ),
        ));
  }

  Widget _buildMessageInput() {
    return Row(children: [
      Expanded(
        child: entryField('Enter message', _controller.messageInputController),
      ),
      IconButton(
          onPressed: () {
            // _controller.sendMessage(widget.receiverData["id"]);
            _controller.sendMessageWithNotification(
                _controller.auth.currentUser!.uid, widget.receiverData["id"]);
          },
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          ))
    ]);
  }
}
