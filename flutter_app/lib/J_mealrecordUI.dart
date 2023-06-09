import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _fireStore = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class FoodItem {
  final String name;
  final double calories;
  final double carbohydrate;
  final double protein;
  final double fat;
  final double sugar;
  final double sodium;

  FoodItem({
    required this.name,
    required this.calories,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.sugar,
    required this.sodium,
  });
}

class DietRecordPage extends StatefulWidget {
  @override
  _DietRecordPageState createState() => _DietRecordPageState();
}

class _DietRecordPageState extends State<DietRecordPage> {
  String selectedMeal = '아침';
  List<String> foodList = [];
  List<double> calories = [];
  List<double> carbohydrate = [];
  List<double> protein = [];
  List<double> fat = [];
  List<double> sugar = [];
  List<double> sodium = [];
  double totalCalories = 0;
  double totalCarbohydrate = 0;
  double totalProtein = 0;
  double totalFat = 0;
  double totalSugar = 0;
  double totalSodium = 0;
  List<FoodItem> selectedFoodList = [];
  String? mood = '전혀 그렇지 않다';
  bool? hasAlcoholAppointment;
  bool? isTraveling;
  bool? overeating;

  void _submitSurvey() {
    _fireStore.collection('survey_eating').add({
      'mood': mood,
      'alcohol': hasAlcoholAppointment,
      'travel': isTraveling,
      'overeating': overeating,
    }).then((value) {
      // 저장이 성공하면 수행할 작업
      print('설문조사 데이터가 성공적으로 저장되었습니다.');
    }).catchError((error) {
      // 저장이 실패하면 수행할 작업
      print('설문조사 데이터 저장에 실패했습니다: $error');
    });
  }

  // API 관련 변수
  final String apiKey = '060aad69e43b44f39027';
  final String baseUrl = 'http://openapi.foodsafetykorea.go.kr/api/sample/I2790/xml';

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
            SizedBox(height: 16),
            Text(
              '검색',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xffFF923F), width: 3,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xffFF923F),
                    width: 3,
                  ),
                ),
                hintText: '음식을 검색하세요',
              ),
              maxLines: null,
              onChanged: (value) {
                _searchFoodList(value);
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
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
            SizedBox(height: 16),
            Text(
              '먹은 음식:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            // 선택된 음식 표시
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedFoodList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(selectedFoodList[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          // 선택된 음식 삭제
                          _removeFood(index);
                        });
                      },
                    ),
                  );
                },
              ),
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
          title: Text('식사 시간'),
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

  void _searchFoodList(String keyword) async {
    // API 요청을 위한 URL 생성
    String url = '$baseUrl/1/5/DESC_KOR=$keyword';

    // API 호출
    http.Response response = await http.get(Uri.parse(url));

    // XML 파싱
    if (response.statusCode == 200) {
      xml.XmlDocument xmlDocument = xml.XmlDocument.parse(response.body);

      setState(() {
        foodList.clear();
        xmlDocument.findAllElements('row').forEach((element) {
          String foodName = element.findElements('DESC_KOR').first.innerText;
          foodList.add(foodName);
        });
      });
    } else {
      print('API 요청 실패');
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
      double kcal =
          double.tryParse(element.findElements('NUTR_CONT1').first.innerText) ??
              0;
      double carbohydrate =
          double.tryParse(element.findElements('NUTR_CONT2').first.innerText) ??
              0;
      double protein =
          double.tryParse(element.findElements('NUTR_CONT3').first.innerText) ??
              0;
      double fat =
          double.tryParse(element.findElements('NUTR_CONT4').first.innerText) ??
              0;
      double sugar =
          double.tryParse(element.findElements('NUTR_CONT5').first.innerText) ??
              0;
      double sodium =
          double.tryParse(element.findElements('NUTR_CONT6').first.innerText) ??
              0;

      setState(() {
        FoodItem selectedFood = FoodItem(
          name: foodName,
          calories: kcal,
          carbohydrate: carbohydrate,
          protein: protein,
          fat: fat,
          sugar: sugar,
          sodium: sodium,
        );

        selectedFoodList.add(selectedFood);

        totalCalories += kcal;
        totalCarbohydrate += carbohydrate;
        totalProtein += protein;
        totalFat += fat;
        totalSugar += sugar;
        totalSodium += sodium;
      });
    } else {
      print('Error: API 요청에 실패했습니다');
    }
  }

  void _showSurveyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('오늘의 기분은'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('지금 우울한가요?'),
                    SizedBox(height: 8),
                    RadioListTile<String>(
                      title: Text('전혀 그렇지 않다'),
                      value: '전혀 그렇지 않다',
                      groupValue: mood,
                      onChanged: (value) {
                        setState(() {
                          mood = value;
                        });
                      },
                      activeColor: Color(0xffFF923F),
                    ),
                    RadioListTile<String>(
                      title: Text('그렇지 않다'),
                      value: '그렇지 않다',
                      groupValue: mood,
                      onChanged: (value) {
                        setState(() {
                          mood = value;
                        });
                      },
                      activeColor: Color(0xffFF923F),
                    ),
                    RadioListTile<String>(
                      title: Text('보통이다'),
                      value: '보통이다',
                      groupValue: mood,
                      onChanged: (value) {
                        setState(() {
                          mood = value;
                        });
                      },
                      activeColor: Color(0xffFF923F),
                    ),
                    RadioListTile<String>(
                      title: Text('그렇다'),
                      value: '그렇다',
                      groupValue: mood,
                      onChanged: (value) {
                        setState(() {
                          mood = value;
                        });
                      },
                      activeColor: Color(0xffFF923F),
                    ),
                    RadioListTile<String>(
                      title: Text('매우 그렇다'),
                      value: '매우 그렇다',
                      groupValue: mood,
                      onChanged: (value) {
                        setState(() {
                          mood = value;
                        });
                      },
                      activeColor: Color(0xffFF923F),
                    ),
                    SizedBox(height: 16),
                    Text('오늘 술 약속이 있나요?'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('예'),
                        Radio(
                          value: true,
                          groupValue: hasAlcoholAppointment,
                          onChanged: (value) {
                            setState(() {
                              hasAlcoholAppointment = value;
                            });
                          },
                          activeColor: Color(0xffFF923F),
                        ),
                        SizedBox(width: 16),
                        Text('아니오'),
                        Radio(
                          value: false,
                          groupValue: hasAlcoholAppointment,
                          onChanged: (value) {
                            setState(() {
                              hasAlcoholAppointment = value;
                            });
                          },
                          activeColor: Color(0xffFF923F),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('오늘 여행할 계획이 있나요?'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('예'),
                        Radio(
                          value: true,
                          groupValue: isTraveling,
                          onChanged: (value) {
                            setState(() {
                              isTraveling = value;
                            });
                          },
                          activeColor: Color(0xffFF923F),
                        ),
                        SizedBox(width: 16),
                        Text('아니오'),
                        Radio(
                          value: false,
                          groupValue: isTraveling,
                          onChanged: (value) {
                            setState(() {
                              isTraveling = value;
                            });
                          },
                          activeColor: Color(0xffFF923F),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('오늘은 과식 또는 폭식을 했나요?'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('예'),
                        Radio(
                          value: true,
                          groupValue: overeating,
                          onChanged: (value) {
                            setState(() {
                              overeating = value;
                            });
                          },
                          activeColor: Color(0xffFF923F),
                        ),
                        SizedBox(width: 16),
                        Text('아니오'),
                        Radio(
                          value: false,
                          groupValue: overeating,
                          onChanged: (value) {
                            setState(() {
                              overeating = value;
                            });
                          },
                          activeColor: Color(0xffFF923F),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _submitSurvey();
                    Navigator.pop(context);
                  },
                  child: Text(
                    '등록',
                    style: TextStyle(
                      color: Color(0xffFF923F),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeFood(int index) {
    FoodItem removedFood = selectedFoodList.removeAt(index);
    totalCalories -= removedFood.calories;
    totalCarbohydrate -= removedFood.carbohydrate;
    totalProtein -= removedFood.protein;
    totalFat -= removedFood.fat;
    totalSugar -= removedFood.sugar;
    totalSodium -= removedFood.sodium;
  }
}
