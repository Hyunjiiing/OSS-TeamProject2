import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'mainPage.dart';
import 'recipe.dart';
import 'calendar.dart';
import 'settings.dart';
import 'J_foxUI.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOX',
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController? controller;
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message.notification!.title.toString());
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      final snackBar;
      snackBar =
          SnackBar(content: Text(message.notification!.title.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

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
      body: TabBarView(
        children: <Widget>[
          MainPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '메인 페이지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: '레시피 추천',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더 뷰',
          ),
        ],
        selectedItemColor: Color(0xFFff923f),
        onTap: (index) {
          // 화면 이동 처리 구현 (메인 페이지, 레시피 추천 페이지, 캘린더 뷰 페이지)
        },
      ),
    );
  }
}
