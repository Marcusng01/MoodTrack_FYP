import 'package:ai_mood_tracking_application/commons/chat_trailing_icon.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/services/message_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:ai_mood_tracking_application/ui/student/message%20(OLD)/message_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CounsellorDashboard extends StatefulWidget {
  CounsellorDashboard({super.key, required this.title});
  final String title;
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<CounsellorDashboard> createState() => _MyCounsellorDashboardState();
}

class _MyCounsellorDashboardState extends State<CounsellorDashboard> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = AppTextStyles.smallBlackText;
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _auth = AuthService();
  final MessageService _messageService = MessageService();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.streamUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          Map<String, dynamic> userData = snapshot.data!.docs.first.data();
          return counsellorDashboardScreen(userData);
        });
  }

  Widget counsellorDashboardScreen(Map<String, dynamic> userData) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Your Students"),
      ),
      body: Padding(padding: const EdgeInsets.all(8.0), child: list(userData)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AuthService().signOut();
        },
        label: const Text("Sign Out"),
      ),
      bottomNavigationBar: counsellorBottomNavBar(),
    );
  }

  Widget list(Map<String, dynamic> userData) {
    return Column(children: <Widget>[
      // ListHeader(),
      searchBar(),
      listBody(userData),
    ]);
  }

  Widget searchBar() {
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
      return SearchBar(
        hintText: "Search",
        controller: controller,
        padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0)),
        onTap: () {
          controller.openView();
        },
        onChanged: (_) {
          controller.openView();
        },
        leading: const Icon(Icons.search),
      );
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(5, (int index) {
        final String item = 'item $index';
        return ListTile(
          title: Text(item),
          onTap: () {
            setState(() {
              controller.closeView(item);
            });
          },
        );
      });
    });
  }

  Widget listBody(Map<String, dynamic> counselorData) {
    return StreamBuilder(
        stream: _auth.streamSearchStudentDocs(counselorData["counselorCode"]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          int itemCount = snapshot.data!.docs.length;
          return Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  /*TO DO: Change itemCount */
                  itemCount: itemCount,
                  itemBuilder: (BuildContext ctxt, int index) {
                    // Access each document's data
                    Map<String, dynamic> studentData =
                        snapshot.data!.docs[index].data();
                    // Pass both counselorData and studentData to listItem
                    return listItem(counselorData, studentData);
                  }),
            ),
          );
        });
  }

  Widget listItem(
      Map<String, dynamic> counselorData, Map<String, dynamic> studentData) {
    String username = studentData['username'];
    return StreamBuilder(
        stream: _messageService.getLatestMessage(
            counselorData["id"], studentData["id"]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...",
                style: AppTextStyles.mediumGreyText,
                overflow: TextOverflow.ellipsis);
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
                  title: listItemTitle(username, latestMessageData),
                  subtitle: listItemSubtitle(
                      counselorData, studentData, latestMessageData),
                ),
              ));
        });
  }

  Widget listItemTitle(
      String username, Map<String, dynamic> latestMessageData) {
    String timeString = latestMessageData.isNotEmpty
        ? customTimestampToString(latestMessageData["timestamp"])
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

  String customTimestampToString(Timestamp time) {
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

  Widget listItemSubtitle(
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

  Widget counsellorBottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'Analyse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.blueSurface,
      onTap: _onItemTapped,
    );
  }

  // Widget ListHeader() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(12.0),
  //     decoration: const BoxDecoration(
  //       color: AppColors.lightBlueSurface,
  //     ),
  //     child: const Text(
  //       "Your Students",
  //       style: AppTextStyles.largeBlueText,
  //     ),
  //   );
  // }
}
