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

  String _gender = '';
  String _activityLevel = '';
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

  Future<void> _calculateDailyCalorie() async {
    if (_formKey.currentState!.validate()) {
      final String age = _ageController.text;
      final String height = _heightController.text;
      final String weight = _weightController.text;
      final String calorie = _calorieController.text;

      final String level = _activityLevel.split(': ')[1];

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
          _comparisonMessage = '다이어트에 딱 좋은 칼로리예요!';
        } else if (dailyCalorie < userCalorie &&
            (userCalorie - dailyCalorie) > 200) {
          _comparisonMessage = '섭취 칼로리량을 줄일 필요가 있어요!';
        } else {
          _comparisonMessage = '';
        }
      } else {
        setState(() {
          _apiResponse = 'Error: ${response.statusCode}';
          _comparisonMessage = '';
        });
      }
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _calorieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('다이어트를 위한 일일섭취칼로리량'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '나이',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '나이를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                '성별',
                style: TextStyle(fontSize: 18.0),
              ),
              DropdownButtonFormField(
                value: _gender,
                items: genderOptions.map((String option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _gender = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '성별을 선택해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                '키 (cm)',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '키를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                '체중 (kg)',
                style: TextStyle(fontSize: 18.0),
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '체중을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                '활동 수준',
                style: TextStyle(fontSize: 18.0),
              ),
              DropdownButtonFormField(
                value: _activityLevel,
                items: activityLevelOptions.map((String option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _activityLevel = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '활동 수준을 선택해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _calculateDailyCalorie,
                child: Text('계산하기'),
              ),
              SizedBox(height: 16.0),
              if (_apiResponse.isNotEmpty)
                Text(
                  '일일 섭취 칼로리량: $_apiResponse',
                  style: TextStyle(fontSize: 18.0),
                ),
              if (_comparisonMessage.isNotEmpty)
                Text(
                  _comparisonMessage,
                  style: TextStyle(fontSize: 18.0),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
