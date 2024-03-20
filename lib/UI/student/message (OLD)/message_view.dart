import 'package:ai_mood_tracking_application/commons/text_field.dart';
import 'package:ai_mood_tracking_application/ui/student/message%20(OLD)/message_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageView extends StatefulWidget {
  final String receiverUsername;
  final String receiverUserId;
  const MessageView({
    super.key,
    required this.receiverUsername,
    required this.receiverUserId,
  });
  @override
  State<MessageView> createState() => _MyMessageViewState();
}

class _MyMessageViewState extends State<MessageView> {
  MessageController _controller = MessageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUsername)),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _controller.messageService
            .getMessages(widget.receiverUserId, _controller.getCurrentUserId()),
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
        child: Column(
          children: [
            Text(data['senderEmail']),
            Text(data['message']),
          ],
        ));
  }

  Widget _buildMessageInput() {
    return Row(children: [
      Expanded(
        child: entryField('Enter message', _controller.messageInputController),
      ),
      IconButton(
          onPressed: () {
            _controller.sendMessage(widget.receiverUserId);
          },
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          ))
    ]);
  }
}
