import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(home: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final String foxImageUrl =
      "https://cdn.pixabay.com/photo/2018/07/30/04/23/fox-illustration-3571760_960_720.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Fox",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            foxImageUrl,
            width: 100,
            height: 150,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10), //apply padding horizontal or vertical only
              child: Text(
                "이름 : 여우입니다",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //double underline
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10), //apply padding horizontal or vertical only
              child: Text(
                "나이 : 26살",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //double underline
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10), //apply padding horizontal or vertical only
              child: Text(
                "몸무게 : 55kg",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //double underline
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10), //apply padding horizontal or vertical only
              child: Text(
                "성별 : 여자",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //double underline
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.grey)),
    onPressed: () {},
              child: Text('아침'),
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.grey)),
              onPressed: () {},
              child: Text('점심'),
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.grey)),
              onPressed: () {},
              child: Text('저녁'),
            ),
          ]),
        ],
      ),
    );
  }
}
