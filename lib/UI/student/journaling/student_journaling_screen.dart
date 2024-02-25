import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/logic/journaling/writing_controller.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/styles/text_styles.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentJournalingScreen extends StatefulWidget {
  StudentJournalingScreen({super.key, required this.title});
  final String title;
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<StudentJournalingScreen> createState() =>
      _MyStudentJournalingScreenState();
}

class _MyStudentJournalingScreenState extends State<StudentJournalingScreen> {
  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final WritingController _writingController = WritingController();
  ValueNotifier<DateTime> reflectButtonNofitier = ValueNotifier<DateTime>(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  Map<DateTime, String> _events = {};

  Color dateColor(date) {
    Color color = AppColors().ratingColor(_events[date]);
    return color;
  }

  TextStyle dateTextStyle(date) {
    TextStyle textStyle = AppTextStyles().ratingTextStyle(_events[date]);
    return textStyle;
  }

  Widget? _dayBuilder(
      {required DateTime date,
      BoxDecoration? decoration,
      bool? isDisabled,
      bool? isSelected,
      bool? isToday,
      TextStyle? textStyle}) {
    Widget? dayWidget;
    if (_events.containsKey(date)) {
      Color color = dateColor(date);
      dayWidget = Container(
        color: isSelected == true ? color : color.withOpacity(0.6),
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                MaterialLocalizations.of(context).formatDecimal(date.day),
                style: dateTextStyle(date),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 27.5),
              //   child: Container(
              //     height: 4,
              //     width: 4,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       color: isSelected == true
              //           ? Colors.white
              //           : AppColors.greySurface,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    }
    return dayWidget;
  }

  Widget calendar() {
    return CalendarDatePicker2(
      value: [_selectedDay],
      onValueChanged: (date) => {
        _selectedDay = date.first!,
        reflectButtonNofitier.value = _selectedDay
      },
      config: CalendarDatePicker2Config(
        // Other configurations...
        dayBuilder: _dayBuilder,
      ),
      // Other configurations...
    );
  }

  void navigateToReflect() {
    Navigator.pushNamed(context, '/Student/Reflect', arguments: {
      "date": _selectedDay,
    });
  }

  Widget reflectButton() {
    return ValueListenableBuilder(
        valueListenable: reflectButtonNofitier,
        builder: (context, value, _) {
          return ElevatedButton(
            onPressed:
                _events[value] == null ? null : () => navigateToReflect(),
            child: _events[value] == null
                ? const Text("Please write a Journal first")
                : const Text("Reflect"),
          );
        });
  }

  Widget studentJournalingScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[calendar(), reflectButton()],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_events[_selectedDay] == null) {
            Navigator.pushNamed(context, "/Student/Journaling/Writing",
                arguments: {
                  "date": _selectedDay,
                  "rating": _events[_selectedDay]
                });
          } else {
            Navigator.pushNamed(context, "/Student/Journaling/Result",
                arguments: {
                  "date": _selectedDay,
                  "rating": _events[_selectedDay]
                });
          }
        },
        label: const Text("Journal"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<DateTime, String>>(
        stream: _writingController.getDateTimeRatingMapAsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            _events = snapshot.data!;
            return studentJournalingScreen();
          } else {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          }
        });
  }
}
