import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
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
  static const TextStyle optionStyle = AppTextStyles.smallBlackText;
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _auth = AuthService();

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

  Widget list(Map<String, dynamic> userData) {
    return Column(children: <Widget>[
      // ListHeader(),
      searchBar(),
      listBody(userData),
    ]);
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
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/Student/Message Counsellor');
        },
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              username,
              style: AppTextStyles.largeBlackText,
            ),
            subtitle: const Text("You: Last Message",
                style: AppTextStyles.mediumGreyText,
                overflow: TextOverflow.ellipsis),
          ),
        ));
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
