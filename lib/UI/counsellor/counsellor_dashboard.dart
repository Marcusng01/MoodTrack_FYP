import 'package:ai_mood_tracking_application/commons/analyse_list_item.dart';
import 'package:ai_mood_tracking_application/commons/message_list_item.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/services/message_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/ui/counsellor/counsellor_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final AuthService _auth = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final MessageService _messageService = MessageService();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.streamUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return counsellorDashboardLoadingScreen();
          }
          Map<String, dynamic> userData = snapshot.data!.docs.first.data();
          return counsellorDashboardScreen(userData);
        });
  }

  Widget counsellorDashboardLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu), // Hamburger icon
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CounsellorProfile(title: 'Profile')));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Column(children: <Widget>[searchBar(), const Text("Loading...")]),
      ),
      bottomNavigationBar: counsellorBottomNavBar(),
    );
  }

  Widget counsellorDashboardScreen(Map<String, dynamic> userData) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Your Students"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu), // Hamburger icon
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CounsellorProfile(title: 'Profile')));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[searchBar(), listBody(userData)]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AuthService().signOut();
        },
        label: const Text("Sign Out"),
      ),
      bottomNavigationBar: counsellorBottomNavBar(),
    );
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
                    // Pass both counselorData and studentData to messageListItem
                    return _selectedIndex == 0
                        ? MessageListItem(
                            counselorData: counselorData,
                            studentData: studentData,
                            messageService: _messageService)
                        : AnalyseListItem(
                            counselorData: counselorData,
                            studentData: studentData,
                            firestoreService: _firestoreService);
                  }),
            ),
          );
        });
  }

  // Widget analyseListItem(Map<String, dynamic> studentData) {
  //   String username = studentData['username'];
  //   String journalData = studentData["j"]
  //         return GestureDetector(
  //             onTap: () {

  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => AnalyseView(
  //                         username: userData["username"],
  //                         userId: userData["id"])))
  //             },
  //             child: Card(
  //               child: ListTile(
  //                 leading: const Icon(Icons.person),
  //                 title: messageListItemTitle(username, latestMessageData),
  //                 subtitle: messageListItemSubtitle(
  //                     counselorData, studentData, latestMessageData),
  //               ),
  //             ));
  //       });
  // }

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
