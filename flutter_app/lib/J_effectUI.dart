import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '다이어트를 위한 일일섭취칼로리량',
      theme: ThemeData(
        primaryColor: Color(0xffFF923F),
      ),
      home: DietCalculatorScreen(),
    );
  }
}

class DietCalculatorScreen extends StatefulWidget {
  @override
  _DietCalculatorScreenState createState() => _DietCalculatorScreenState();
}

class _DietCalculatorScreenState extends State<DietCalculatorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();

  String? _gender;
  int? _activityLevel;
  String _apiResponse = '';
  String _comparisonMessage = '';

  List<String> genderOptions = ['Male', 'Female'];
  List<String> activityLevelOptions = [
    'Level 1: 운동을 거의 또는 전혀 하지 않음',
    'Level 2: 일주일에 1-3회 운동',
    'Level 3: 일주일에 4-5회 운동',
    'Level 4: 매일 운동 또는 강도 높은 운동 주 3~4회',
    'Level 5: 강도 높은 운동 일주일에 6~7회',
    'Level 6: 매일 매우 강도 높은 운동 또는 육체노동',
  ];

  String _getActivityLevel(String? selectedLevel) {
    switch (selectedLevel) {
      case 'Level 1: 운동을 거의 또는 전혀 하지 않음':
        return 'level_1';
      case 'Level 2: 일주일에 1-3회 운동':
        return 'level_2';
      case 'Level 3: 일주일에 4-5회 운동':
        return 'level_3';
      case 'Level 4: 매일 운동 또는 강도 높은 운동 주 3~4회':
        return 'level_4';
      case 'Level 5: 강도 높은 운동 일주일에 6~7회':
        return 'level_5';
      case 'Level 6: 매일 매우 강도 높은 운동 또는 육체노동':
        return 'level_6';
      default:
        return '';
    }
  }

  Future<void> _calculateDailyCalorie() async {
    if (_formKey.currentState!.validate()) {
      final String age = _ageController.text;
      final String height = _heightController.text;
      final String weight = _weightController.text;
      final String calorie = _calorieController.text;
      final String level = _getActivityLevel(activityLevelOptions[_activityLevel! - 1]);

      final String apiUrl =
          '/dailycalorie?age=$age&gender=$_gender&height=$height&weight=$weight&activitylevel=$level';

      final Uri apiUri = Uri.https(
        'fitness-calculator.p.rapidapi.com',
        apiUrl,
      );

      final response = await http.get(
        apiUri,
        headers: {
          'X-RapidAPI-Key': '7befde939bmshf1936e77aba73e1p1b4eebjsn4982a4ae4831',
          'X-RapidAPI-Host': 'fitness-calculator.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _apiResponse = response.body;
        });

        final int dailyCalorie = int.parse(response.body);
        final int userCalorie = int.parse(calorie);

        if (dailyCalorie > userCalorie && (dailyCalorie - userCalorie) > 100) {
          _comparisonMessage = '조금 더 먹어도 괜찮아요!';
        } else if (dailyCalorie == userCalorie) {
          _comparisonMessage = '다이어트에 딱 좋은 칼로리량이에요!';
        } else if (dailyCalorie < userCalorie && (userCalorie - dailyCalorie) > 100) {
          _comparisonMessage = '조금 덜 먹으면 좋아요!';
        } else {
          _comparisonMessage = '적정 칼로리량이에요!';
        }
      } else {
        setState(() {
          _apiResponse = 'Error: ${response.statusCode}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('다이어트를 위한 일일섭취칼로리량'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '개인 정보',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text('성별'),
                DropdownButton<String>(
                  value: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                Text('나이'),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '나이를 입력하세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Text('키 (cm)'),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '키를 입력하세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Text('체중 (kg)'),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '체중을 입력하세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Text('활동 수준'),
                DropdownButton<int>(
                  value: _activityLevel,
                  onChanged: (int? value) {
                    setState(() {
                      _activityLevel = value;
                    });
                  },
                  items: activityLevelOptions
                      .asMap()
                      .entries
                      .map((entry) => DropdownMenuItem<int>(
                    value: entry.key + 1,
                    child: Text(entry.value),
                  ))
                      .toList(),
                ),
                SizedBox(height: 16.0),
                Text('하루에 먹을 칼로리'),
                TextFormField(
                  controller: _calorieController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '하루에 먹을 칼로리를 입력하세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  color: Color(0xffFF923F),
                  child: ElevatedButton(
                    onPressed: _calculateDailyCalorie,
                    child: Text('일일섭취칼로리량 계산하기'),
                  ),
                ),
                SizedBox(height: 16.0),
                Text('일일섭취칼로리량: $_apiResponse'),
                Text('비교 결과: $_comparisonMessage'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
