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
            title: Text('식재료를 입력하세요',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Color(0xffFF923F),
            elevation: 0,
          ),
          body: Padding(
            padding:EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.dining_outlined),
                      prefixIcon: Icon(Icons.dining),
                      hintText: 'input',
                      labelText: '식재료'
                  ),
                ),
                Text('레시피 추천',
                    style: TextStyle(height: 2.0, fontSize: 18, fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_downward),
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