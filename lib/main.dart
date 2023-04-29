import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
            children: [
              Text('식단 운동 루틴 효과'),
              Text('정보가 많을수록 보다 정확한 결과를 얻을 수 있어요.'),
              Text('*필수'),
              Text('다이어트 기간'),
              Text('하루 총 섭취 칼로리'),
              Text('하루 소모 칼로리'),
              Text('*권장'),
              Text('탄/단/지 비율'),
              Text('주로 먹을 음식'),
              Text('일주일 운동 루틴'),
            ],
          )
      ),
    );
  }
}