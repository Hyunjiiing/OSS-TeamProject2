import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ChangeNotifierProvider<Settings>(
    create: (context) => Settings(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFFF923F),
        brightness: Provider
            .of<Settings>(context)
            .isDarkMode
            ? Brightness.dark
            : Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('다이어트 설정')),
        body: SettingScreen(),
      ),
    );
  }
}
class SettingScreen extends StatefulWidget {
@override
_SettingScreenState createState() => _SettingScreenState();
}