import 'package:ai_mood_tracking_application/commons/text_field.dart';
import 'package:ai_mood_tracking_application/data/mood.dart';
import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:ai_mood_tracking_application/ui/student/journaling/journal_reflect/journal_reflect_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class JournalReflectView extends StatefulWidget {
  JournalReflectView({super.key, required this.title});
  final String title;
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<JournalReflectView> createState() => _MyJournalReflectViewState();
}

class _MyJournalReflectViewState extends State<JournalReflectView> {
  JournalReflectController controller = JournalReflectController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    controller.date = args["date"];
  }

  Widget moodCarouselItemTitle(mood) {
    String moodTitle = mood[0].toUpperCase() + mood.substring(1);
    return Text('You felt $moodTitle', style: AppTextStyles.largeBlackText);
  }

  Widget moodCarouselItemSentence(sentence) {
    sentence = "The sentence: $sentence";
    return Text(sentence, style: AppTextStyles.mediumBlueText);
  }

  Widget moodCarouselItem(mood, sentence) {
    Mood moodData = moodDataCollection[mood] ?? errorMood;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(color: AppColors.lightBlueSurface),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            moodCarouselItemTitle(mood),
            moodCarouselItemSentence(sentence),
            Text(moodData.validation, style: AppTextStyles.mediumBlueText),
            Text("This may help: ${moodData.solution}",
                style: AppTextStyles.mediumBlueText),
            Text("Reflection Prompt: ${moodData.reflection}",
                style: AppTextStyles.mediumBlueText)
          ]),
    );
  }

  Widget moodCarousel() {
    List<dynamic> moodsDynamic = controller.doc["mood"];
    List<String> moods = moodsDynamic.cast<String>();

    List<dynamic> sentencesDynamic = controller.doc["sentences"];
    List<String> sentences = sentencesDynamic.cast<String>();
    List<Widget> moodCarouselItems = IterableZip([moods, sentences])
        .where((pair) => pair[0] != "neutral")
        .map<Widget>((pair) => moodCarouselItem(pair[0], pair[1]))
        .toList();
    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            header("Your Emotions"),
            CarouselSlider(
                options: CarouselOptions(height: 400.0),
                // items: ["angry", "confusion", "surprise"].map((mood) {
                //   return Builder(builder: (BuildContext context) {
                //     return moodCarouselItem(mood);
                //   });
                // }).toList(),
                items: moodCarouselItems)
          ],
        ));
  }

  Widget header(text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: AppColors.lightBlueSurface,
      ),
      child: Text(
        text,
        style: AppTextStyles.largeBlackText,
      ),
    );
  }

  Widget reflectionListItem(reflection) {
    return Card(
      child: ListTile(
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
              controller.firestoreService
                  .deleteReflection(controller.date, reflection);
            }
          },
        ),
        title: Text(reflection,
            style: AppTextStyles.mediumBlackText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget reflectionListBody() {
    List<Widget> contents;
    try {
      List<dynamic> reflectionsDynamic = controller.doc["reflections"];
      List<String> reflections = reflectionsDynamic.cast<String>();
      if (reflections.isEmpty) {
        throw Exception();
      }
      contents = reflections
          .map<Widget>((reflection) => reflectionListItem(reflection))
          .toList();
    } catch (e) {
      contents = [
        const ListTile(
          title: Text("No Reflections Yet",
              style: AppTextStyles.largeBlackText,
              overflow: TextOverflow.ellipsis),
        )
      ];
    }

    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: ListView(
          scrollDirection: Axis.vertical,
          /*TO DO: Change itemCount */
          children: contents,
        ),
      ),
    );
  }

  Widget reflectionList() {
    return SizedBox(
      height: 270,
      child: Column(children: <Widget>[
        header("Reflection List"),
        reflectionListBody(),
      ]),
    );
  }

  Widget reflectionPanelHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Set the border radius here
      ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              controller.panelController.close();
            },
          ),
          Container(
            width: 100,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius:
                  BorderRadius.circular(10), // Set the border radius here
            ),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              controller.firestoreService.createOrUpdateReflection(
                  controller.date, controller.newReflectionTextController.text);
              controller.panelController.close();
              controller.newReflectionTextController.text = "";
            },
          ),
        ],
      ),
    );
  }

  Widget reflectionPanelBody() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.all(30.0),
        child: entryField(
            'New Reflection', controller.newReflectionTextController),
      )
    ]);
  }

  Widget JournalReflectView(context) {
    String formattedDate = DateFormat("MMMM d, yyyy").format(controller.date);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("${widget.title} for $formattedDate"),
          ),
          body: SlidingUpPanel(
            header: reflectionPanelHeader(),
            defaultPanelState: PanelState.CLOSED,
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.30,
            controller: controller.panelController,
            onPanelClosed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                controller.isFabVisible = true;
              });
            },
            backdropEnabled: true,
            panel: reflectionPanelBody(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  moodCarousel(),
                  reflectionList(),
                ],
              ),
            ),
          ),
          floatingActionButton: controller.isFabVisible
              ? FloatingActionButton.extended(
                  onPressed: () {
                    controller.panelController.open();
                    setState(() {
                      controller.isFabVisible = false;
                    });
                  },
                  label: const Text("Reflect"),
                )
              : null,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream:
            controller.firestoreService.getJournalByDateStream(controller.date),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return JournalReflectView(context);
          } else if (snapshot.hasData) {
            controller.doc = snapshot.data!;
            return JournalReflectView(context);
          } else {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          }
        });
  }
}
