import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '다이어트 앱',
      theme: ThemeData(
        primaryColor: Color(0xFFff923f),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: '나의 다이어트 앱',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title}) : super();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFff923f),
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // 설정 페이지로 이동
          },
        ),
      ),
    );
  }
}
