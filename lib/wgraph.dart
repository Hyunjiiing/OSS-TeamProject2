import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(WeightTrackerApp());
}

class WeightTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeightTrackerPage(),
    );
  }
}

class WeightTrackerPage extends StatefulWidget {
  @override
  _WeightTrackerPageState createState() => _WeightTrackerPageState();
}

class _WeightTrackerPageState extends State<WeightTrackerPage> {
  List<FlSpot> weightEntries = [];
  TextEditingController weightController = TextEditingController();

  void _saveWeightEntry() {
    setState(() {
      double? weight = double.tryParse(weightController.text);
      if (weight != null) {
        weightEntries.add(FlSpot(weightEntries.length.toDouble(), weight));
        weightController.clear();
      }
    });
  }