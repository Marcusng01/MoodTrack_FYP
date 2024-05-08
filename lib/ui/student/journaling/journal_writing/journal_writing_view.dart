import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:ai_mood_tracking_application/ui/student/journaling/journal_writing/journal_writing_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalWritingView extends StatefulWidget {
  JournalWritingView({super.key});
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<JournalWritingView> createState() => _MyWritingScreenState();
}

class _MyWritingScreenState extends State<JournalWritingView> {
  JournalWritingController controller = JournalWritingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    controller.date = args["date"];
    controller.selectedRating = args["rating"] ?? controller.selectedRating;
  }

  Widget journalInputField() {
    if (controller.modifyPlaceholder) {
      controller.journalInputController.text = controller.placeholder;
      controller.modifyPlaceholder = false;
    }
    return TextField(
        scrollController: controller.scrollController,
        controller: controller.journalInputController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: "Write about your day..."),
        style: AppTextStyles.mediumBlackText);
  }

  Widget journalInputContainer(context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.70,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        color: AppColors.greySurface,
        child: Scrollbar(
            controller: controller.scrollController,
            child: journalInputField()));
  }

  Widget ratingButton(String rating) {
    String text = rating[0].toUpperCase() + rating.substring(1);
    Color color = AppColors().ratingColor(rating);
    TextStyle textStyle = AppTextStyles().ratingTextStyle(rating);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            controller.selectedRating = rating;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: controller.selectedRating == rating
                ? color
                : color.withOpacity(0.2),
          ),
          child: Text(
            text,
            style: controller.selectedRating == rating
                ? textStyle
                : AppTextStyles.smallBlackText,
          ),
        ),
      ),
    );
  }

  Widget buttonRows() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ratingButton('good'),
          ratingButton('average'),
          ratingButton('great'),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ratingButton('awful'),
          ratingButton('bad'),
          ratingButton('unsure'),
        ],
      ),
    ]);
  }

  Widget rateDayContainer() {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "How was your day?",
                  style: AppTextStyles.mediumBlackText,
                ),
                buttonRows(),
              ],
            )));
  }

  Widget writingScreen(context) {
    String formattedDate = DateFormat("MMMM d, yyyy").format(controller.date);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(formattedDate),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                journalInputContainer(context),
                rateDayContainer()
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(20),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("The AI is thinking...",
                              style: AppTextStyles.largeBlackText),
                          CircularProgressIndicator()
                        ],
                      ),
                    ),
                  );
                },
              );

              List<String> moods = await controller.firestoreService
                  .storeJournal(controller.journalInputController,
                      controller.date, controller.selectedRating);
              controller.sendJournalNotification(moods, widget.user!.uid,
                  await controller.auth.getCurrentCounsellorId());
              Navigator.of(context).pop(); // Close the dialog

              Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/Student/Journaling/Result",
                  arguments: {
                    "date": controller.date,
                    "rating": controller.selectedRating
                  },
                  (Route<dynamic> route) =>
                      route.settings.name == '/Student/Journaling');
            },
            label: const Text("Save"),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.firestoreService.getJournalByDate(controller.date),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return writingScreen(context);
          } else if (snapshot.hasData) {
            var doc = snapshot.data!;
            controller.placeholder = doc["journal"];
            return writingScreen(context);
          } else {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          }
        });
  }
}
