import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DietRecordPage(),
    );
  }
}

class DietRecordPage extends StatefulWidget {
  @override
  _DietRecordPageState createState() => _DietRecordPageState();
}

class _DietRecordPageState extends State<DietRecordPage> {
  String selectedMeal = '아침';
  String memo = '';
  List<int> calories = [];
  List<String> foodList = [];

  // API 관련 변수
  final String apiKey = '060aad69e43b44f39027';
  final String baseUrl =
      'http://openapi.foodsafetykorea.go.kr/api/sample/I2790/xml';

  @override
  Widget build(BuildContext context) {
    int totalCalories = calories.isNotEmpty ? calories.reduce((a, b) => a + b) : 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFF923F),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('오늘의 식단 기록하기'),
        actions: [
          TextButton(
            onPressed: () {
              _showSurveyDialog();
            },
            child: Text(
              '식단 등록',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${DateTime.now().toString().split(' ')[1].substring(0, 5)}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      child: Text(selectedMeal),
                      onPressed: () {
                        _showMealSelectionDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFF923F),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text('음식 찾기'),
                  onPressed: () {
                    _showFoodSearchDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFF923F),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              '메모',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '메모를 작성해주세요',
              ),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  memo = value;
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // API로부터 받은 음식 정보를 표시하는 위젯 추가
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: foodList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(foodList[index]),
                          onTap: () {
                            setState(() {
                              // 선택한 음식을 식단에 추가
                              calories.add(100); // 예시로 100 칼로리 추가
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '총 칼로리: $totalCalories',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('식사 선택'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text('아침'),
                  onTap: () {
                    setState(() {
                      selectedMeal = '아침';
                    });
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 8),
                GestureDetector(
                  child: Text('점심'),
                  onTap: () {
                    setState(() {
                      selectedMeal = '점심';
                    });
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 8),
                GestureDetector(
                  child: Text('저녁'),
                  onTap: () {
                    setState(() {
                      selectedMeal = '저녁';
                    });
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 8),
                GestureDetector(
                  child: Text('간식'),
                  onTap: () {
                    setState(() {
                      selectedMeal = '간식';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFoodSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('음식 검색'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 음식 검색 관련 위젯 추가
            ],
          ),
        );
      },
    );
  }

  void _showSurveyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('현재 상태 체크'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상태 체크 관련 위젯 추가
              ElevatedButton(
                child: Text('식단 등록'),
                onPressed: () {
                  // 식단을 데이터에 저장하는 로직 추가
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFF923F),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}