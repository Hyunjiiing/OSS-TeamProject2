import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

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
  double totalCalories = 0;
  double totalCarbohydrate = 0;
  double totalProtein = 0;
  double totalFat = 0;
  double totalSugar = 0;
  double totalSodium = 0;

  // API 관련 변수
  final String apiKey = '060aad69e43b44f39027';
  final String baseUrl = 'http://openapi.foodsafetykorea.go.kr/api/sample/I2790/xml';

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
                              _fetchFoodInfo(foodList[index]);
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
              '총 칼로리: ${totalCalories.toStringAsFixed(1)} kcal',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '총 탄수화물: ${totalCarbohydrate.toStringAsFixed(1)} g',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '총 단백질: ${totalProtein.toStringAsFixed(1)} g',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '총 지방: ${totalFat.toStringAsFixed(1)} g',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '총 당류: ${totalSugar.toStringAsFixed(1)} g',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '총 나트륨: ${totalSodium.toStringAsFixed(1)} mg',
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
        return Dialog(
          child: Container(
            width: 300, // 원하는 너비 설정
            height: 400, // 원하는 높이 설정
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    _searchFood(value);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '음식을 검색해주세요',
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: foodList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(foodList[index]),
                        onTap: () {
                          setState(() {
                            // 선택한 음식을 식단에 추가
                            _fetchFoodInfo(foodList[index]);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  void _searchFood(String keyword) async {
    // API 요청을 위한 URL 생성
    String url = '$baseUrl/1/5/DESC_KOR=$keyword';

    // API 호출
    http.Response response = await http.get(Uri.parse(url));

    // XML 파싱
    if (response.statusCode == 200) {
      xml.XmlDocument xmlDocument = xml.XmlDocument.parse(response.body);

      List<String> results = [];
      Iterable<xml.XmlElement> elements = xmlDocument.findAllElements('row');

      for (var element in elements) {
        String foodName = element.findElements('DESC_KOR').first.innerText; // 음식 이름 가져오기
        results.add(foodName);
      }

      setState(() {
        foodList = results;
      });
    } else {
      print('API 요청에 실패하였습니다.');
    }
  }


  void _fetchFoodInfo(String foodName) async {
    // API 요청을 위한 URL 생성
    String url = '$baseUrl/1/1/DESC_KOR=$foodName';

    // API 호출
    http.Response response = await http.get(Uri.parse(url));

    // XML 파싱
    if (response.statusCode == 200) {
      xml.XmlDocument xmlDocument = xml.XmlDocument.parse(response.body);

      xml.XmlElement element = xmlDocument.findAllElements('row').first;
      double kcal = double.tryParse(element.findElements('NUTR_CONT1').first.innerText) ?? 0;
      double carbohydrate = double.tryParse(element.findElements('NUTR_CONT2').first.innerText) ?? 0;
      double protein = double.tryParse(element.findElements('NUTR_CONT3').first.innerText) ?? 0;
      double fat = double.tryParse(element.findElements('NUTR_CONT4').first.innerText) ?? 0;
      double sugar = double.tryParse(element.findElements('NUTR_CONT5').first.innerText) ?? 0;
      double sodium = double.tryParse(element.findElements('NUTR_CONT6').first.innerText) ?? 0;

      setState(() {
        calories.add(kcal.round());
        totalCalories += kcal;
        totalCarbohydrate += carbohydrate;
        totalProtein += protein;
        totalFat += fat;
        totalSugar += sugar;
        totalSodium += sodium;
      });
    } else {
      print('API 요청에 실패하였습니다.');
    }
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