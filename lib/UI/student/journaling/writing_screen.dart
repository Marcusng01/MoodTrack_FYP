import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/logic/journaling/writing_controller.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WritingScreen extends StatefulWidget {
  WritingScreen({super.key});
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<WritingScreen> createState() => _MyWritingScreenState();
}

class _MyWritingScreenState extends State<WritingScreen> {
  final ScrollController _scrollController = ScrollController();
  final WritingController _writingController = WritingController();
  TextEditingController _journalInputController = TextEditingController();
  String _selectedRating = "unsure";
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String placeholder = "";
  bool modifyPlaceholder = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    date = args["date"];
    _selectedRating = args["rating"] ?? _selectedRating;
  }

  Widget journalInputField() {
    if (modifyPlaceholder) {
      _journalInputController.text = placeholder;
      modifyPlaceholder = false;
    }
    return TextField(
        scrollController: _scrollController,
        controller: _journalInputController,
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
            controller: _scrollController, child: journalInputField()));
  }

  Widget ratingButton(String rating) {
    String text = rating[0].toUpperCase() + rating.substring(1);
    Color color = AppColors().ratingColor(rating);
    TextStyle textStyle = AppTextStyles().ratingTextStyle(rating);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRating = rating;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: _selectedRating == rating ? color : color.withOpacity(0.2),
          ),
          child: Text(
            text,
            style: _selectedRating == rating
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
    String formattedDate = DateFormat("MMMM d, yyyy").format(date);
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

              await _writingController.storeJournal(
                  _journalInputController, date, _selectedRating);

              Navigator.of(context).pop(); // Close the dialog

              Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/Student/Journaling/Result",
                  arguments: {"date": date, "rating": _selectedRating},
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
        future: _writingController.getJournalByDate(date),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return writingScreen(context);
          } else if (snapshot.hasData) {
            var doc = snapshot.data!;
            placeholder = doc["journal"];
            return writingScreen(context);
          } else {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          }
        });
  }
}
