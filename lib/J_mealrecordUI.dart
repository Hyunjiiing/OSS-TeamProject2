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
              Text('오늘의 식단 기록하기'),
              Text('0000년 00월 00일'),
              Text('아침: '),
              Text('칼로리: '),
              Text('점심: '),
              Text('칼로리: '),
              Text('저녁: '),
              Text('칼로리: '),
            ],
          )
      ),
    );
  }
}