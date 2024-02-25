import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/logic/journaling/writing_controller.dart';
import 'package:ai_mood_tracking_application/logic/reflect/reflecting_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentRemindersScreen extends StatefulWidget {
  StudentRemindersScreen({
    super.key,
    required this.title,
  });
  final String title;
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<StudentRemindersScreen> createState() =>
      _MyStudentRemindersScreenState();
}

class _MyStudentRemindersScreenState extends State<StudentRemindersScreen> {
  final _reflectingController = ReflectingController();
  final _writingController = WritingController();
  late List<ReminderItem> _data;
  late List<bool> _isExpanded;
  late bool _isInitialiseIsExpanded = true;

  ListTile reminderListTile(date, reflection) {
    return ListTile(
      title: Text(reflection),
      trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () =>
              {_reflectingController.deleteReflection(date, reflection)}),
    );
  }

  ExpansionPanel reminderExpansionPanel(index, item) {
    DateTime date = item.headerValue;
    String formattedDate = DateFormat('MMMM d, yyyy').format(date);
    List<String> reflections = item.expandedValues;
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(formattedDate),
        );
      },
      body: Column(
        children: reflections.map<Widget>((String reflection) {
          return reminderListTile(date, reflection);
        }).toList(),
      ),
      isExpanded: _isExpanded[index],
    );
  }

  List<ExpansionPanel> expansionPanelList() {
    return _data.asMap().entries.map<ExpansionPanel>((entry) {
      int index = entry.key;
      ReminderItem item = entry.value;
      return reminderExpansionPanel(index, item);
    }).toList();
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded[index] = isExpanded;
          });
        },
        children: expansionPanelList());
  }

  Widget studentRemindersScreen(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_buildPanel()],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _writingController.getJournalsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return studentRemindersScreen(context);
          } else if (snapshot.hasData) {
            _data = _reflectingController
                .createReminderItemsFromQuerySnapshot(snapshot.data!);
            if (_isInitialiseIsExpanded) {
              _isExpanded = List<bool>.filled(_data.length, false);
              if (_isExpanded.isNotEmpty) {
                _isExpanded[0] = true;
              }
              _isInitialiseIsExpanded = false;
            }
            return studentRemindersScreen(context);
          } else {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          }
        });
  }
}
