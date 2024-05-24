import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:ai_mood_tracking_application/ui/student/journaling/journal_calendar/journal_calendar_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AnalyseView extends StatefulWidget {
  final String username;
  final String userId;
  AnalyseView({
    super.key,
    required this.username,
    required this.userId,
  });
  final User? user = AuthService().currentUser;
  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  State<AnalyseView> createState() => _MyAnalyseViewState();
}

class _MyAnalyseViewState extends State<AnalyseView> {
  JournalCalendarController controller = JournalCalendarController();
  final FirestoreService _firestoreService = FirestoreService();
  late String chartTitle = "";
  DateRangePickerController _datePickerController = DateRangePickerController();
  DateTime now = DateTime.now();
  DateRangePickerView view = DateRangePickerView.month;

  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String getMonthName(int monthNumber) {
    // Adjust for 0-based indexing
    if (monthNumber < 1 || monthNumber > 12) {
      throw ArgumentError('Month number must be between 1 and 12');
    }

    return monthNames[monthNumber - 1];
  }

  @override
  void initState() {
    super.initState();
    _setDateRange(PickerDateRange(
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 1)
            .subtract(const Duration(days: 1))));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<DateTime, String>>(
        stream: controller.fireStoreService
            .getDateTimeRatingMapAsStream(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            controller.events = snapshot.data!;
            return analyseScreen();
          } else {
            return analyseScreen(); // Show a loading spinner while waiting for the data
          }
        });
  }

  Widget analyseScreen() {
    // Widget analyseScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.username),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            datePicker(context),
            radialChart(),
          ],
        ),
      ),
    );
  }

  Widget datePicker(BuildContext context) {
    return SfDateRangePicker(
      view: DateRangePickerView.month,
      initialSelectedRange: _datePickerController.selectedRange,
      controller: _datePickerController,
      selectionMode: DateRangePickerSelectionMode.range,
      showActionButtons: true,
      onSubmit: (Object? value) {
        _setDateRange(value);
      },
      onCancel: () {
        setState(() {
          _datePickerController.selectedRange = PickerDateRange(
            DateTime(now.year, now.month, 1),
            DateTime(now.year, now.month + 1, 1)
                .subtract(const Duration(days: 1)),
          );
          _datePickerController.view = DateRangePickerView.month;
          _datePickerController.displayDate = DateTime(now.year, now.month, 1);
          chartTitle = '';
        });
      },
      cellBuilder:
          (BuildContext buildContext, DateRangePickerCellDetails cellDetails) {
        if (_datePickerController.view == DateRangePickerView.century) {
          final int yearValue = (cellDetails.date.year ~/ 10) * 10;
          return Container(
            width: cellDetails.bounds.width,
            height: cellDetails.bounds.height,
            alignment: Alignment.center,
            child: Text('$yearValue - ${yearValue + 9}'),
          );
        } else if (_datePickerController.view == DateRangePickerView.year) {
          return Container(
            width: cellDetails.bounds.width,
            height: cellDetails.bounds.height,
            alignment: Alignment.center,
            child: Text(getMonthName(cellDetails.date.month)),
          );
        } else if (_datePickerController.view == DateRangePickerView.decade) {
          return Container(
            width: cellDetails.bounds.width,
            height: cellDetails.bounds.height,
            alignment: Alignment.center,
            child: Text(cellDetails.date.year.toString()),
          );
        } else {
          return _dayBuilder(
            date: cellDetails.date,
            decoration: null,
            isDisabled: null,
            isSelected: _isDateSelected(cellDetails.date),
            isToday: cellDetails.date == DateTime.now(),
            textStyle: null,
          );
        }
      },
    );
  }

  Widget _dayBuilder({
    required DateTime date,
    BoxDecoration? decoration,
    bool? isDisabled,
    bool? isSelected,
    bool? isToday,
    TextStyle? textStyle,
  }) {
    Widget dayWidget = Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Text(
            MaterialLocalizations.of(context).formatDecimal(date.day),
            style: controller.dateTextStyle(date),
          ),
          // Add other customizations as needed
        ],
      ),
    );
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
              // Add other customizations as needed
            ],
          ),
        ),
      );
    }
    return dayWidget;
  }

  bool _isDateSelected(DateTime date) {
    // Implement logic to check if the date is selected
    // For example:
    return _datePickerController.selectedRange?.startDate != null &&
        date.isAfter(_datePickerController.selectedRange!.startDate!) &&
        date.isBefore(_datePickerController.selectedRange!.endDate ??
            _datePickerController.selectedRange!.startDate!);
  }

  void _setDateRange(dynamic value) {
    if (value is PickerDateRange) {
      setState(() {
        _datePickerController.selectedRange = value;
        if (value.endDate == null) {
          chartTitle = DateFormat('dd/MM/yyyy').format(value.startDate!);
        } else {
          chartTitle =
              '${DateFormat('dd/MM/yyyy').format(value.startDate!)} - ${DateFormat('dd/MM/yyyy').format(value.endDate! ?? value.startDate!)}';
        }
      });
    }
  }

  Widget radialChart() {
    return StreamBuilder(
        stream: _firestoreService.streamJournals(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Expanded(child: Text("Loading..."));
          }

          List<Map<String, dynamic>> journals = snapshot.data!.docs.map((doc) {
            return doc.data();
          }).toList();

          List<MoodData> moodData = _getMoodCount(journals);

          return Expanded(
              child: SfCircularChart(
            title: ChartTitle(text: chartTitle),
            // Bind data source
            series: <CircularSeries>[
              DoughnutSeries<MoodData, String>(
                dataSource: moodData,
                xValueMapper: (MoodData moodData, _) => moodData.mood,
                yValueMapper: (MoodData moodData, _) => moodData.count,
                pointColorMapper: (MoodData moodData, _) =>
                    AppColors.getColorForEmotion(moodData.mood, Colors.black),
                enableTooltip: true,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
            legend: const Legend(isVisible: true),
          ));
        });
  }

  List<MoodData> _getMoodCount(List<Map<String, dynamic>> journals) {
    var moodCount = <MoodData>[];
    if (_datePickerController.selectedRange != null) {
      Timestamp start =
          Timestamp.fromDate(_datePickerController.selectedRange!.startDate!);
      Timestamp end = _datePickerController.selectedRange!.endDate != null
          ? Timestamp.fromDate(_datePickerController.selectedRange!.endDate!)
          : start;
      var count = {};
      for (var entry in journals) {
        if (entry['date'].compareTo(start) >= 0 &&
            entry['date'].compareTo(end) <= 0) {
          for (var mood in entry['mood']) {
            if (mood != "neutral") {
              count.update(
                mood,
                (existingValue) =>
                    existingValue is double ? existingValue + 1.0 : 1.0,
                ifAbsent: () => 1.0,
              );
            }
          }
        }
      }
      count.forEach((k, v) => moodCount.add(MoodData(k, v)));
    }
    return moodCount;
  }
}

class MoodData {
  MoodData(this.mood, this.count);
  final String mood;
  final double count;
}
