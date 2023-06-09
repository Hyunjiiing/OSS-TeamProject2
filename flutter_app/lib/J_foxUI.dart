import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int level = 0; // 초기 레벨 설정
  int experience = 0; // 초기 경험치 설정
  int cumulativeExerciseTime = 0; // 누적 운동 시간
  int consumedCalories = 0; // 소모 칼로리
  bool isDataSubmitted = false; // 데이터가 이미 제출되었는지 여부

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    checkDataSubmission();
  }

  void checkDataSubmission() {
    String userId = "yC5fWuwq5RsfKAL1wgxh"; // 사용자 ID
    FirebaseFirestore.instance
        .collection('input_check')
        .doc(userId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          bool isSubmitted = snapshot.get('input');
          isDataSubmitted = isSubmitted ?? false; // 데이터가 이미 제출되었음을 표시합니다.
        });
      }
    });
  }


  void calculateExperience(int exerciseTime) {
    if (isDataSubmitted) return; // 이미 데이터가 제출되었으면 운동 시간 입력을 중지합니다.

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
    setState(() {});
  }

  void calculateExperienceFromCalories(int calories) {
    if (isDataSubmitted) return; // 이미 데이터가 제출되었으면 하루 소모 칼로리 입력을 중지합니다.

    if (calories >= 500) {
      experience += 100;
    }

    while (experience >= getRequiredExperience(level) && level < 30) {
      level++;
      experience -= getRequiredExperience(level - 1);
    }
    setState(() {});
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
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close),
              ),
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
                      Positioned(
                        left: 0,
                        child: Text(
                          '0',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Text(
                          getRequiredExperience(level).toString(),
                          style: TextStyle(fontSize: 12),
                        ),
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
                        if (isDataSubmitted) return; // 이미 데이터가 제출되었으면 운동 시간 입력을 중지합니다.

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            int exerciseTime = 0;

                            return AlertDialog(
                              title: Text('오늘의 운동 시간은?'),
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
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (exerciseTime >= 360) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('정말이에요?'),
                                            content: Text('정직한 운동 시간을 입력해주세요.'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
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
                                    } else {
                                      calculateExperience(exerciseTime);
                                      cumulativeExerciseTime += exerciseTime;
                                      isDataSubmitted = true; // 데이터가 제출되었음을 표시합니다.
                                      Navigator.pop(context);
                                    }
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
                      child: Text('운동 시간 입력'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFF923F),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (isDataSubmitted) return; // 이미 데이터가 제출되었으면 소모 칼로리 입력을 중지합니다.

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        int calories = 0;

                        return AlertDialog(
                          title: Text('오늘의 소모 칼로리는?'),
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
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                if (calories >= 2500) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('정말이에요?'),
                                        content: Text('정직하게 입력해 주세요.'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
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
                                } else {
                                  calculateExperienceFromCalories(calories);
                                  isDataSubmitted = true; // 데이터가 제출되었음을 표시합니다.
                                  Navigator.pop(context);
                                }
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
