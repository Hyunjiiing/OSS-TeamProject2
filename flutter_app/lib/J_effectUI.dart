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

  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> activityLevelOptions = [
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('총 일일에너지소비량 계산기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '나이',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _age = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              '성별',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButtonFormField<String>(
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value;
                });
              },
              items: genderOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              '키',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _height = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              '체중',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              '활동 수준',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButtonFormField<String>(
              value: _activityLevel,
              onChanged: (value) {
                setState(() {
                  _activityLevel = value;
                });
              },
              items: activityLevelOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateDailyCalorie,
              child: Text('일일 에너지소비량 계산'),
            ),
          ],
        ),
      ),
    );
  }
}
