import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('폭스 키우기'),
              backgroundColor: Color(0xFF923F),
            ),
            body: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 2 / 5,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text('폭스', style: TextStyle(fontSize: 18),),
                SizedBox(height: 5),
                Text('Lv. 1', style: TextStyle(fontSize: 16, color: Colors.grey),),
                SizedBox(height: 10),
                Text('폭스의 경험치', style: TextStyle(fontSize: 16),),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 20,
                        color: Color(0xFF923F),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text('누적 운동 시간', style: TextStyle(fontSize: 16),),
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 120,
                        height: 20,
                        color: Color(0xFF923F),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('운동 입력'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('응모하기'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
