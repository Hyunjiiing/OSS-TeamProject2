import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

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
      snackBar = SnackBar(content: Text(message.notification!.title.toString()));
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '사용자 이름: 오우아',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '체중: 57kg',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
                width: 500,
                height: 0.2,
                child: Divider(color: Colors.grey, thickness: 1.0)),
            Text(
              '먹어봤자 다 아는맛이다.. 오늘도 화이팅이야!',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
                width: 500,
                height: 0.2,
                child: Divider(color: Colors.grey, thickness: 1.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 버튼이 눌렸을 때 수행할 작업
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('버튼이 눌렸습니다.')));
                  },
                  child: Text('아침'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff923f),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 버튼이 눌렸을 때 수행할 작업
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('버튼이 눌렸습니다.')));
                  },
                  child: Text('점심'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff923f),
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 버튼이 눌렸을 때 수행할 작업
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('버튼이 눌렸습니다.')));
                  },
                  child: Text('저녁'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff923f),
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 버튼이 눌렸을 때 수행할 작업
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('버튼이 눌렸습니다.')));
                  },
                  child: Text('간식!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff923f),
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 버튼이 눌렸을 때 수행할 작업
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('버튼이 눌렸습니다.')));
                  },
                  child: Text('체중 그래프'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff923f),
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 버튼이 눌렸을 때 수행할 작업
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('버튼이 눌렸습니다.')));
                  },
                  child: Text('일일 섭취량'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff923f),
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
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