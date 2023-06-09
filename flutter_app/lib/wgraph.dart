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
  bool showErrorMessage = false;

  void _saveWeightEntry() {
    setState(() {
      double? weight = double.tryParse(weightController.text);
      if (weight != null) {
        weightEntries.add(FlSpot(weightEntries.length.toDouble(), weight));
        weightController.clear();
        showErrorMessage = false;
      } else {
        showErrorMessage = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFff923f),
        title: Text(
          '체중 변화 그래프',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 8, // 수정: 앱바의 그림자 크기 조정
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // 수정: 그래프와 앱바 사이의 간격 조정
        child: Column(
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
                      curveSmoothness: 0.5,
                      dotData: FlDotData(show: false),
                      colors: [
                        const Color(0xFFff923f),
                      ],
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [
                          const Color(0x33ff923f),
                        ],
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
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
                        return '${(value + 1).toInt()}일';
                      },
                      reservedSize: 30,
                      margin: 10,
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 20,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFEAEAEA),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFEAEAEA),
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0), // 수정: 그래프와 하단 위젯 사이의 간격 조정
            Column(
              children: [
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '몸무게를 입력하세요',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFff923f)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  cursorColor: Color(0xFFff923f),
                ),
                SizedBox(height: 8.0),
                if (showErrorMessage)
                  Text(
                    '체중을 입력해주세요',
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _saveWeightEntry,
                  child: Text('저장'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFff923f),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
