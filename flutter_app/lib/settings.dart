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

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
    ListTile(
    title: Text('푸시 알림 설정'),
    trailing: Consumer<Settings>(
    builder: (context, settings, _) {
    return Switch(
    value: settings.notificationEnabled,
    onChanged: (value) {
    setState(() {
    settings.notificationEnabled = value;
    });
    },
    );
    },
    ),
    ),
    ListTile(
    title: Text('테마'),
    trailing: DropdownButton<ThemeMode>(
    value: Provider.of<Settings>(context).themeMode,
    items: [
    DropdownMenuItem(child: Text('기본 테마'), value: ThemeMode.light),
    DropdownMenuItem(child: Text('다크 모드'), value: ThemeMode.dark),
    ],
    onChanged: (value) {
    setState(() {
    Provider.of<Settings>(context, listen: false).themeMode = value!;
    });
    },
    ),
    ),
    ListTile(
    title: Text('언어 설정'),
    trailing: DropdownButton<Language>(
    value: Provider.of<Settings>(context).language,
    items: [
    DropdownMenuItem(child: Text('한국어'), value: Language.korean),
      DropdownMenuItem(child: Text('영어'), value: Language.english),
    ],
      onChanged: (value) {
        setState(() {
          Provider.of<Settings>(context, listen: false).language = value!;
        });
      },
    ),
    ),
        ],
    );
  }
}

class Settings extends ChangeNotifier {
  bool _notificationEnabled = true;
  ThemeMode _themeMode = ThemeMode.light;
  Language _language = Language.korean;

  bool get notificationEnabled => _notificationEnabled;
  set notificationEnabled(bool value) {
    _notificationEnabled = value;
    notifyListeners();
    _saveSettingsToSharedPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
    _saveSettingsToSharedPrefs();
  }
  Language get language => _language;
  set language(Language value) {
    _language = value;
    notifyListeners();
    _saveSettingsToSharedPrefs();
  }

