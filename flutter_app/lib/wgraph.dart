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
  bool showErrorMessage = false; // 수정: 오류 메시지를 표시할지 여부를 나타내는 상태 변수

  void _saveWeightEntry() {
    setState(() {
      double? weight = double.tryParse(weightController.text);
      if (weight != null) {
        weightEntries.add(FlSpot(weightEntries.length.toDouble(), weight));
        weightController.clear();
        showErrorMessage = false; // 수정: 오류 메시지를 초기화
      } else {
        showErrorMessage = true; // 수정: 오류 메시지를 표시
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
                    // 수정 시작
                    barWidth: 4, // 선의 너비를 4로 설정하여 두껍게 변경
                    // 수정 끝
                    belowBarData: BarAreaData(
                      show: true,
                      colors: [
                        const Color(0x33ff923f), // 그래프 아래 영역 색상 변경
                      ],
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    interval: 20, // 선들이 표시되는 간격을 20으로 변경
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
                  show: true, // 그리드 라인을 표시
                  drawHorizontalLine: true, // 수평 라인 표시
                  horizontalInterval: 20, // 수평 라인 간격 설정
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFEAEAEA), // 수직 라인 색상 변경
                      strokeWidth: 1, // 수직 라인 너비 변경
                    );
                  },
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFEAEAEA), // 수평 라인 색상 변경
                      strokeWidth: 1, // 수평 라인 너비 변경
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column( // 수정: 에러 메시지를 컬럼으로 감싸서 여러 줄 표시 가능
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
                if (showErrorMessage) // 수정: 오류 메시지가 표시되도록 조건부 위젯 사용
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
          ),
        ],
      ),
    );
  }
}
