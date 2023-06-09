import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  int level = 0; // 초기 레벨 설정
  int experience = 0; // 초기 경험치 설정
  int cumulativeExerciseTime = 0; // 누적 운동 시간
  int consumedCalories = 0; // 소모 칼로리

  void calculateExperience(int exerciseTime) {
    if (level < 10) {
      experience += (exerciseTime ~/ 40) * 100;
    } else if (level < 20) {
      experience += (exerciseTime ~/ 60) * 100;
    } else {
      experience += (exerciseTime ~/ 90) * 100;
    }

    while (experience >= getRequiredExperience(level) && level < 30) {
      level++;
      experience -= getRequiredExperience(level - 1);
    }
  }

  void calculateExperienceFromCalories(int calories) {
    if (calories >= 500) {
      experience += 100;
    }

    while (experience >= getRequiredExperience(level) && level < 30) {
      level++;
      experience -= getRequiredExperience(level - 1);
    }
  }

  int getRequiredExperience(int level) {
    if (level == 0) {
      return 100;
    } else {
      return 500 + (level - 1) * 200;
    }
  }

  String formatExerciseTime(int exerciseTime) {
    int hours = exerciseTime ~/ 60;
    int minutes = exerciseTime % 60;
    return '$hours시간 $minutes분';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('폭스 키우기'),
              backgroundColor: Color(0xffFF923F),
            ),
            body: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 2 / 5,
                  child: Image.asset('images/foxcharacter.png'),
                ),
                SizedBox(height: 10),
                Text(
                  '폭스',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  'Lv. $level',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  '폭스의 경험치',
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: (experience / getRequiredExperience(level)) *
                            MediaQuery.of(context).size.width,
                        height: 20,
                        color: Color(0xffFF923F),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '누적 운동 시간',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  formatExerciseTime(cumulativeExerciseTime),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            int exerciseTime = 0;

                            return AlertDialog(
                              title: Text('운동 입력'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('분 단위로 운동 시간을 입력하세요'),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      exerciseTime = int.parse(value);
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    calculateExperience(exerciseTime);
                                    cumulativeExerciseTime += exerciseTime;
                                    Navigator.pop(context);
                                  },
                                  child: Text('확인'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xffFF923F),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('운동 입력'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFF923F),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        int calories = 0;

                        return AlertDialog(
                          title: Text('하루 소모 칼로리 입력'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('칼로리 단위로 소모 칼로리를 입력하세요'),
                              SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  calories = int.parse(value);
                                },
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                calculateExperienceFromCalories(calories);
                                Navigator.pop(context);
                              },
                              child: Text('확인'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffFF923F),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('하루 소모 칼로리 입력'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFF923F),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
