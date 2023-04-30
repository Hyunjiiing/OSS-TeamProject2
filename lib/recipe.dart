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
          appBar: AppBar(
            title: Text('식재료를 입력하세요'),
            backgroundColor: Color(0xffFF923F),
            elevation: 0,
          ),
          body: Padding(
            padding:EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '식재료:'
                    )
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              child: SizedBox(
                  height: 70,
                  child: Icon(Icons.dining_outlined, size:60)
              )
          ),
        )
    );
  }
}