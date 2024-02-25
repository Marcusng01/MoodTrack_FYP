import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class StudentMessageScreen extends StatefulWidget {
  StudentMessageScreen({super.key, required this.title});
  final String title;
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<StudentMessageScreen> createState() => _MyStudentMessageScreenState();
}

class _MyStudentMessageScreenState extends State<StudentMessageScreen> {
  List<chat.Message> _messages = [];
  final _user = const chat.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  late String uid;
  @override
  void initState() {
    super.initState();
    // _user = widget.user!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  void _handleSendPressed(chat.PartialText message) {
    final textMessage = chat.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: "id",
      text: message.text,
    );
    _addMessage(textMessage);
  }

  void _addMessage(chat.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }
}
