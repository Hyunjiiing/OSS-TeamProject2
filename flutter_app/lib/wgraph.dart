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
  double? previousWeight; // 수정: 이전 체중을 저장하기 위한 변수 추가
  bool showErrorMessage = false;
  bool showWeightChangeMessage = false; // 수정: 체중 변화 메시지를 표시하기 위한 변수 추가

  void _saveWeightEntry() {
    setState(() {
      double? weight = double.tryParse(weightController.text);
      if (weight != null) {
        weightEntries.add(FlSpot(weightEntries.length.toDouble(), weight));

        if (previousWeight != null && (weight - previousWeight!).abs() >= 5) {
          showWeightChangeMessage = true;
        } else {
          showWeightChangeMessage = false;
        }

        previousWeight = weight; // 현재 입력한 체중을 이전 체중으로 저장
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
        elevation: 8,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
            SizedBox(height: 16.0),
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
                if (showWeightChangeMessage) // 수정: 체중 변화 메시지 표시 조건 추가
                  Text(
                    '체중 변화가 큽니다!',
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
