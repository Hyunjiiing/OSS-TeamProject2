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
              Text('0000년 00월 00일'),
              Text('나의 폭스 키우기'),
              Text('캐릭터 이미지 | 000의 현재 상태'),
              Text('Level: '),
              Text('경험치 게이지 '),
              Text('~까지 ~ 남았습니다 '),
              Text('경험치 환산하기(버튼)'),
            ],
          )
      ),
    );
  }
}