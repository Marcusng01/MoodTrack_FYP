import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
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
  final FirestoreService _firestoreService = FirestoreService();
  late String chartTitle = "";
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  DateTime now = DateTime.now();

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
    return analyseScreen();
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
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: () => _selectDate(context),
        onPressed: () {},
        label: const Text('Select Month'),
      ),
    );
  }

  Widget datePicker(BuildContext context) {
    return SfDateRangePicker(
      view: DateRangePickerView.month,
      initialSelectedRange: _datePickerController.selectedRange,
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
                  .subtract(const Duration(days: 1)));
          chartTitle = '';
        });
      },
    );
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
