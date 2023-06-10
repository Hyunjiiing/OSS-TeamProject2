import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealList extends StatefulWidget {
  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('meal_record').orderBy('date').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식단 기록',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xffFF923F),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffFF923F)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle: TextStyle(color: Colors.grey),
          prefixStyle: TextStyle(color: Colors.grey),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('식단 기록'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('데이터 가져오기에 오류가 발생했습니다.');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<QueryDocumentSnapshot> _mealRecords = snapshot.data!.docs;

            return ListView.builder(
              itemCount: _mealRecords.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = _mealRecords[index];
                Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                if (data == null) {
                  return Container();
                }

                final documentId = document.id;
                final List<dynamic> contents = data['contents'] ?? <String>[];

                String content = '';
                if (contents.isNotEmpty && contents.every((element) => element is String)) {
                  content = contents.join(', ');
                }

                final dateString = data['date'] as String?;
                final date = DateTime.tryParse(dateString ?? '');

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
                    FirebaseFirestore.instance.collection('meal_record').doc(documentId).delete();
                  },
                  child: ListTile(
                    title: Text(content),
                    subtitle: Text(date != null ? date.toString() : ''),
                    trailing: Icon(Icons.edit),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MealList(),
  ));
}