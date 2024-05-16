import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/ui/student/journaling/journal_calendar/journal_calendar_controller.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JournalCalendarView extends StatefulWidget {
  JournalCalendarView({super.key, required this.title});
  final String title;
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<JournalCalendarView> createState() => _MyStudentJournalingScreenState();
}

class _MyStudentJournalingScreenState extends State<JournalCalendarView> {
  JournalCalendarController controller = JournalCalendarController();

  Widget? _dayBuilder(
      {required DateTime date,
      BoxDecoration? decoration,
      bool? isDisabled,
      bool? isSelected,
      bool? isToday,
      TextStyle? textStyle}) {
    Widget? dayWidget;
    if (controller.events.containsKey(date)) {
      Color color = controller.dateColor(date);
      dayWidget = Container(
        color: isSelected == true ? color : color.withOpacity(0.6),
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                MaterialLocalizations.of(context).formatDecimal(date.day),
                style: controller.dateTextStyle(date),
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
      value: [controller.selectedDay],
      onValueChanged: (date) => {
        controller.selectedDay = date.first!,
        controller.buttonNofitier.value = controller.selectedDay
      },
      config: CalendarDatePicker2Config(
        // Other configurations...
        dayBuilder: _dayBuilder,
      ),
      // Other configurations...
    );
  }

  Widget reflectButton() {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime selectedDay = controller.selectedDay;
    bool isFabEnabled =
        selectedDay.isBefore(today) || selectedDay.isAtSameMomentAs(today);
    if (isFabEnabled) {
      return ValueListenableBuilder(
          valueListenable: controller.buttonNofitier,
          builder: (context, value, _) {
            return ElevatedButton(
              onPressed: controller.events[value] == null
                  ? null
                  : () => controller.navigateToReflect(context),
              child: controller.events[value] == null
                  ? const Text("Please write a Journal first")
                  : const Text("Reflect"),
            );
          });
    } else {
      return ValueListenableBuilder(
          valueListenable: controller.buttonNofitier,
          builder: (context, value, _) {
            return ElevatedButton(
                onPressed: controller.events[value] == null
                    ? null
                    : () => controller.navigateToReflect(context),
                child: const Text("This date is in the future."));
          });
    }
  }

  Widget studentJournalingScreen() {
    return ValueListenableBuilder(
        valueListenable: controller.buttonNofitier,
        builder: (context, value, _) {
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
            floatingActionButton: journalFab(),
          );
        });
  }

  FloatingActionButton? journalFab() {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime selectedDay = controller.selectedDay;
    bool isFabEnabled =
        selectedDay.isBefore(today) || selectedDay.isAtSameMomentAs(today);
    return isFabEnabled
        ? FloatingActionButton.extended(
            onPressed: () {
              if (controller.events[controller.selectedDay] == null) {
                Navigator.pushNamed(
                  context,
                  "/Student/Journaling/Writing",
                  arguments: {
                    "date": controller.selectedDay,
                    "rating": controller.events[controller.selectedDay],
                  },
                );
              } else {
                Navigator.pushNamed(
                  context,
                  "/Student/Journaling/Result",
                  arguments: {
                    "date": controller.selectedDay,
                    "rating": controller.events[controller.selectedDay],
                  },
                );
              }
            },
            label: const Text("Journal"),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<DateTime, String>>(
        stream: controller.fireStoreService
            .getDateTimeRatingMapAsStream(widget.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            controller.events = snapshot.data!;
            return studentJournalingScreen();
          } else {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting for the data
          }
        });
  }
}
