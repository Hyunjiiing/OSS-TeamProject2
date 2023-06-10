import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식단 기록',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xffFF923F),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _stream;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _stream = firestore.collection('식단').orderBy('날짜').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식단 기록'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              cursorColor: const Color(0xffFF923F),
              decoration: InputDecoration(
                labelText: '음식 이름 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xffFF923F)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                _onSearchChanged(value);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('데이터 가져오기에 오류가 발생했습니다.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    final documentId = document.id;

                    return Dismissible(
                      key: Key(documentId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        firestore.collection('식단').doc(documentId).delete();
                      },
                      child: ListTile(
                        title: Text(data['음식']),
                        subtitle: Text(data['설명']),
                        trailing: Icon(Icons.edit),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("hi");
          /*
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewDietRecordScreen(), //화면 연결에서 수정
            ),
          );*/
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _stream = firestore
          .collection('식단')
          .where('음식', isEqualTo: value)
          .orderBy('날짜')
          .snapshots();
    });
  }
}
