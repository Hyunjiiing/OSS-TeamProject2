import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식단 기록',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xffFF923F), // 주어진 색상 값
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식단 기록'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('식단').orderBy('날짜').snapshots(), // 날짜 필드를 기준으로 정렬
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('데이터 가져오기에 오류가 발생했습니다.');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                final documentId = document.id;

                return Dismissible(
                  key: Key(documentId), // 각 항목의 고유한 키로 설정
                  direction: DismissDirection.endToStart, // 삭제 액션은 오른쪽에서 왼쪽으로 스와이프
                  background: Container(
                    color: Colors.red, // 삭제 액션 배경색
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    // 항목 삭제 처리
                    firestore.collection('식단').doc(documentId).delete();
                  },
                  child: ListTile(
                    title: Text(data['음식']),
                    subtitle: Text(data['설명']),
                    trailing: Icon(Icons.edit), // 수정 아이콘 추가
                    onTap: () {
                      // 항목 수정 처리
                      // 여기에 수정할 수 있는 화면으로 이동
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
