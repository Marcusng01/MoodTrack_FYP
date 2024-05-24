import 'package:ai_mood_tracking_application/data/reminder_item.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/ui/student/reminders/reminders_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RemindersView extends StatefulWidget {
  RemindersView({
    super.key,
    required this.title,
  });
  final String title;
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<RemindersView> createState() => _MyRemindersViewState();
}

class _MyRemindersViewState extends State<RemindersView> {
  RemindersController controller = RemindersController();

  ListTile reminderListTile(date, reflection) {
    return ListTile(
        title: Text(reflection),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            bool? confirmDelete = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: const Text(
                      'Are you sure you want to delete this reflection?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(false); // User cancelled the action
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(true); // User confirmed the deletion
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );

            if (confirmDelete == true) {
              controller.firestoreService.deleteReflection(date, reflection);
            }
          },
        ));
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
      isExpanded: controller.isExpanded[index],
    );
  }

  List<ExpansionPanel> expansionPanelList() {
    return controller.data.asMap().entries.map<ExpansionPanel>((entry) {
      int index = entry.key;
      ReminderItem item = entry.value;
      return reminderExpansionPanel(index, item);
    }).toList();
  }

  Widget buildPanel() {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            controller.isExpanded[index] = isExpanded;
          });
        },
        children: expansionPanelList());
  }

  Widget remindersView(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [buildPanel()],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.firestoreService.getJournalsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return remindersView(context);
          } else if (snapshot.hasData) {
            controller.data = controller.firestoreService
                .createReminderItemsFromQuerySnapshot(snapshot.data!);
            if (controller.isInitialiseIsExpanded) {
              controller.isExpanded =
                  List<bool>.filled(controller.data.length, false);
              if (controller.isExpanded.isNotEmpty) {
                controller.isExpanded[0] = true;
              }
              controller.isInitialiseIsExpanded = false;
            }
            return remindersView(context);
          } else {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          }
        });
  }
}
