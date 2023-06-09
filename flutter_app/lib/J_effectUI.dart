import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '다이어트를 위한 일일섭취칼로리량 구하기',
      theme: ThemeData(
        primaryColor: Color(0xffFF923F),
        appBarTheme: AppBarTheme(
          color: Color(0xffFF923F),
        ),
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
  late FocusNode _ageFocusNode;
  late FocusNode _heightFocusNode;
  late FocusNode _weightFocusNode;
  late FocusNode _calorieFocusNode;

  @override
  void initState() {
    super.initState();

    // FocusNode들을 초기화
    _ageFocusNode = FocusNode();
    _heightFocusNode = FocusNode();
    _weightFocusNode = FocusNode();
    _calorieFocusNode = FocusNode();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();

  String? _gender;
  int? _activityLevel;
  String _apiResponse = '';
  String _comparisonMessage = '';

  List<String> genderOptions = ['male', 'female'];
  List<String> activityLevelOptions = [
    'Level 1: 운동을 거의 또는 전혀 하지 않음',
    'Level 2: 일주일에 1-3회 적당한 운동',
    'Level 3: 일주일에 4-5회 적당한 운동',
    'Level 4: 매일 운동 또는 강도 높은 운동 주 3~4회',
    'Level 5: 강도 높은 운동 일주일에 6~7회',
    'Level 6: 매일 매우 강도 높은 운동 또는 육체노동',
  ];

  String _getActivityLevel(String? selectedLevel) {
    switch (selectedLevel) {
      case 'Level 1: 운동을 거의 또는 전혀 하지 않음':
        return 'level_1';
      case 'Level 2: 일주일에 1-3회 적당한 운동':
        return 'level_2';
      case 'Level 3: 일주일에 4-5회 적당한 운동':
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
      final int parsedAge = int.parse(age);
      final String height = _heightController.text;
      final int parsedHeight = int.parse(height);
      final String weight = _weightController.text;
      final int parsedWeight = int.parse(weight);
      final String calorie = _calorieController.text;
      final int userCalorie = int.parse(calorie);
      final String level =
      _getActivityLevel(activityLevelOptions[_activityLevel! - 1]);

      final String apiUrl =
          'https://fitness-calculator.p.rapidapi.com/dailycalorie?age=$parsedAge&gender=$_gender&height=$parsedHeight&weight=$parsedWeight&activitylevel=$level';

      final Uri apiUri = Uri.parse(apiUrl);

      final response = await http.get(
        apiUri,
        headers: {
          'X-RapidAPI-Key':
          '7befde939bmshf1936e77aba73e1p1b4eebjsn4982a4ae4831',
          'X-RapidAPI-Host': 'fitness-calculator.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final int weightLossIndex = responseBody.indexOf('"Weight loss"');
        final int caloryIndex =
        responseBody.indexOf('"calory"', weightLossIndex);
        final int colonIndex = responseBody.indexOf(':', caloryIndex);
        final int endIndex = responseBody.indexOf('}', caloryIndex);
        final String weightLossCalorie =
        responseBody.substring(colonIndex + 1, endIndex).trim();

        try {
          final double weightLossCalorieValue = double.parse(weightLossCalorie);
          final int weightLossCalorieInt = weightLossCalorieValue.toInt();
          setState(() {
            _apiResponse = weightLossCalorieInt.toString();
          });

          final int dailyCalorie = weightLossCalorieInt;

          if (dailyCalorie > userCalorie &&
              (dailyCalorie - userCalorie) >= 80) {
            setState(() {
              _comparisonMessage = '조금 더 먹어도 괜찮아요!';
            });
          } else if (dailyCalorie < userCalorie &&
              (userCalorie - dailyCalorie) >= 80) {
            setState(() {
              _comparisonMessage = '조금 덜 먹으면 좋아요!';
            });
          } else {
            setState(() {
              _comparisonMessage = '다이어트에 적당한 칼로리량이에요!';
            });
          }
        } catch (e) {
          setState(() {
            _apiResponse = '';
            _comparisonMessage = '';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('다이어트를 위한 일일섭취칼로리량'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  focusNode: _ageFocusNode,
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '나이를 입력하세요';
                    }
                    return null;
                  },
                  cursorColor: const Color(0xffFF923F),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xffFF923F)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text('키 (cm)'),
                TextFormField(
                  focusNode: _heightFocusNode,
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '키를 입력하세요';
                    }
                    return null;
                  },
                  cursorColor: const Color(0xffFF923F),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xffFF923F)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text('체중 (kg)'),
                TextFormField(
                  focusNode: _weightFocusNode,
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '체중을 입력하세요';
                    }
                    return null;
                  },
                  cursorColor: const Color(0xffFF923F),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xffFF923F)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
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
                      .map(
                        (entry) => DropdownMenuItem<int>(
                      value: entry.key + 1,
                      child: Text(entry.value),
                    ),
                  )
                      .toList(),
                ),
                SizedBox(height: 16.0),
                Text('하루에 먹을 칼로리'),
                TextFormField(
                  focusNode: _calorieFocusNode,
                  controller: _calorieController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '하루에 먹을 칼로리를 입력하세요';
                    }
                    return null;
                  },
                  cursorColor: const Color(0xffFF923F),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xffFF923F)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: ElevatedButton(
                      onPressed: _calculateDailyCalorie,
                      child: Text('결과보기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '권장일일섭취칼로리량: $_apiResponse kcal',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      ' $_comparisonMessage',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    child: Text(
                      '다이어트를 위한 권장 탄단지 비율은 5:3:2 입니다!',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
