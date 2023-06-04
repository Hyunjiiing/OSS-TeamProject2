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
        actions: [
          Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  // 버튼이 눌렸을 때 수행할 작업
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('버튼이 눌렸습니다.')));
                },
                child: Text(
                  '레벨업 하러 가기!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                  primary: Colors.black,
                  backgroundColor: Color(0xFFff923f),
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 15),
                ),
              ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/user_photo.jpg'),
                  radius: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
