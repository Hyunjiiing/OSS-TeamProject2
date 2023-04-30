import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home:MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final String foxImageUrl = "https://cdn.pixabay.com/photo/2018/07/30/04/23/fox-illustration-3571760_960_720.png";

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Image.network(foxImageUrl ,width: 100,
                height: 150,),
          Text("이름 : 여우입니다"),
          Text("나이 : 26살"),
          Text("몸무게 : 55kg"),
          Text("몸무게 : 55kg"),
        ],
      ),
      );
  }
}
