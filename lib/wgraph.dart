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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: weightEntries.length.toDouble() - 1,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: weightEntries,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    colors: [
                      const Color(0xFFff923f), // 그래프 색상 변경
                    ],
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTextStyles: (value) => const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTextStyles: (value) => const TextStyle(
                      color: Colors.black,
                    ),
                    getTitles: (value) {
                      return '${(value + 1).toInt()}일'; // 숫자 뒤에 '일' 추가, 시작 값은 1로 설정
                    },
                    reservedSize: 30,
                    margin: 10,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '몸무게를 입력하세요', // 힌트 텍스트 변경
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFff923f)), // 입력칸 클릭 시 줄 색상 변경
                      ),
    
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}