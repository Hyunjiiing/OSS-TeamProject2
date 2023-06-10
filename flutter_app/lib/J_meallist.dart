import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealList extends StatefulWidget {
  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  late Stream<QuerySnapshot> _stream;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('meal_record').orderBy('날짜').snapshots();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _stream = FirebaseFirestore.instance
          .collection('meal_record')
          .where('음식', isEqualTo: value)
          .orderBy('날짜')
          .snapshots();
    });
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
      home: HomePage(
        onSearchChanged: _onSearchChanged,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(String) onSearchChanged;

  const HomePage({
    required this.onSearchChanged,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late List<DocumentSnapshot> _mealRecords = [];
  late Stream<QuerySnapshot> _stream;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stream = firestore.collection('식단').orderBy('날짜').snapshots();
    _searchController.addListener(_onSearchControllerChanged);
  }

  void _onSearchControllerChanged() {
    widget.onSearchChanged(_searchController.text);
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
                labelText: '검색',
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xffFF923F),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xffFF923F)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('데이터 가져오기에 오류가 발생했습니다.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                _mealRecords = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: _mealRecords.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = _mealRecords[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
                        FirebaseFirestore.instance.collection('meal_record').doc(documentId).delete();
                      },
                      child: ListTile(
                        title: Text(data['음식']),
                        subtitle: Text(data['설명']),
                        trailing: Icon(Icons.edit),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MealList(),
  ));
}