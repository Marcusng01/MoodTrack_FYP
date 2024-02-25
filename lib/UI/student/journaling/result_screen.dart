import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/logic/journaling/writing_controller.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key});
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<ResultScreen> createState() => _MyResultScreenState();
}

class _MyResultScreenState extends State<ResultScreen> {
  final ScrollController _scrollController = ScrollController();
  final WritingController _writingController = WritingController();
  // TextEditingController _journalInputController = TextEditingController();
  String _selectedRating = "unsure";
  late DateTime date;
  late DocumentSnapshot doc;
  String text = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    date = args["date"];
    _selectedRating = args["rating"] ?? _selectedRating;
  }

  // Widget journalInputField() {
  //   return TextField(
  //     scrollController: _scrollController,
  //     controller: _journalInputController,
  //     maxLines: null,
  //     keyboardType: TextInputType.multiline,
  //     decoration: const InputDecoration(
  //         border: InputBorder.none, hintText: "Write about your day..."),
  //   );
  // }

  TextSpan textSpan(sentence, mood) {
    var color = AppColors.getColorForEmotion(mood, AppColors.blackText);
    color = AppColors.darken(color, 0.3);
    TextStyle spanStyle = TextStyle(fontSize: 16.0, color: color);
    return TextSpan(
      text: "($mood) $sentence ",
      style: spanStyle,
    );
  }

  Widget journalInputContainer(context) {
    List<String> sentences = List<String>.from(doc["sentences"]);
    List<String> mood = List<String>.from(doc["mood"]);
    List<TextSpan> textSpans = [];
    for (var pair in IterableZip([sentences, mood])) {
      textSpans.add(textSpan("${pair[0]} ", pair[1]));
    }
    return Container(
        height: MediaQuery.of(context).size.height * 0.70,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        color: AppColors.greySurface,
        child: Scrollbar(
            controller: _scrollController,
            // child: journalInputField()
            /*TO DO: Build Textspans based on sentences and mood from Flask*/
            child: RichText(
              text: TextSpan(
                children: textSpans,
              ),
            )));
  }

  Widget ratingButton(String rating) {
    String text = rating[0].toUpperCase() + rating.substring(1);
    Color color = AppColors().ratingColor(rating);
    TextStyle textStyle = AppTextStyles().ratingTextStyle(rating);
    return Container(
      width: 100.0, // Set the width to 200 pixels
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: _selectedRating == rating ? color : color.withOpacity(0.2),
      ),
      child: Text(
        text,
        style: _selectedRating == rating
            ? textStyle
            : AppTextStyles.mediumBlackText,
      ),
    );
  }

  Widget singleButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ratingButton(_selectedRating),
      ],
    );
  }

  Widget rateDayContainer() {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Your Day Was:",
                  style: AppTextStyles.mediumBlackText,
                ),
                ratingButton(_selectedRating),
              ],
            )));
  }

  Widget resultScreen(context) {
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
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: "edit",
                  onPressed: () {
                    Navigator.pushNamed(context, "/Student/Journaling/Writing",
                        arguments: {
                          "date": date,
                          "rating": _selectedRating,
                          "journal": doc["journal"]
                        });
                  },
                  label: const Text("Edit"),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  heroTag: "reflect",
                  onPressed: () => {
                    Navigator.pushNamed(context, '/Student/Reflect',
                        arguments: {
                          "date": date,
                        })
                  },
                  label: const Text("Reflect"),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _writingController.getJournalByDate(date),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return resultScreen(context);
          } else if (snapshot.hasData) {
            doc = snapshot.data!;
            // _journalInputController =
            //     TextEditingController(text: doc["journal"]);
            /*TO DO: Get Sentences and Mood from FLASK*/
            return resultScreen(context);
          } else {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          }
        });
  }
}
