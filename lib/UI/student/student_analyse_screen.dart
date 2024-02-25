import 'package:ai_mood_tracking_application/logic/auth/auth.dart';
import 'package:ai_mood_tracking_application/styles/color_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StudentAnalyseScreen extends StatefulWidget {
  StudentAnalyseScreen({super.key, required this.title});
  final String title;
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  State<StudentAnalyseScreen> createState() => _MyStudentAnalyseScreenState();
}

class _MyStudentAnalyseScreenState extends State<StudentAnalyseScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Widget radialChart() {
    return Expanded(
        child: SfCircularChart(
      title: ChartTitle(
        text: DateFormat("MMMM d, yyyy").format(_selectedDate),
      ),
      // Bind data source
      series: <CircularSeries>[
        DoughnutSeries<MoodData, String>(
          dataSource: <MoodData>[
            MoodData('Anger', 3),
            MoodData('Sadness', 1),
            MoodData('Confusion', 5),
            MoodData('Joy', 10),
          ],
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
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            radialChart(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _selectDate(context),
        label: const Text('Select Month'),
      ),
    );
  }
}

class MoodData {
  MoodData(this.mood, this.count);
  final String mood;
  final double count;
}
