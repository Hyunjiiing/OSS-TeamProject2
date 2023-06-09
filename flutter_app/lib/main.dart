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
    debugShowCheckedModeBanner: false,
    return MaterialApp(
      title: 'FOX',
      theme: ThemeData(
        primaryColor: Color(0xFFff923f),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'FOX',
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
    controller = TabController(length: 3, vsync: this);

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

    @override
    dispose() {
      controller!.dispose();
      super.dispose();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFff923f),
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Settings()));
          },
        ),
        actions: [
          Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LevelUp()));
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
          Recipe(),
          Calender(),
        ],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        tabs: const <Tab>[
          Tab(
            icon: Icon(Icons.home),
            child: Text('메인 페이지'),
          ),
          Tab(
            icon: Icon(Icons.recommend),
            child: Text('레시피 추천'),
          ),
          Tab(
            icon: Icon(Icons.calendar_today),
            child: Text('캘린더 뷰'),
          ),
        ],
        unselectedLabelColor: Colors.grey,
        labelColor: Color(0xFFff923f),
        indicatorColor: Color(0xFFff923f),
        controller: controller,
      ),
    );
  }
}
