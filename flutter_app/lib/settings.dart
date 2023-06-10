import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFff923f),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xFFff923f),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "설정",
          ),
        ),
        body: ListView(
          children: [
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 40),
              width: MediaQuery.of(context).size.width / 10 * 8,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.alarm,
                        size: 40,
                      ),
                      Text(
                        "   푸시알람 ON/OFF",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 30, color: Colors.grey),
                ],
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 40),
              width: MediaQuery.of(context).size.width / 10 * 8,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 40,
                      ),
                      Text("   사용자 정보", style: TextStyle(fontSize: 20))
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 30, color: Colors.grey),
                ],
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 40),
              width: MediaQuery.of(context).size.width / 10 * 8,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.dark_mode_outlined,
                        size: 40,
                      ),
                      Text("   다크모드", style: TextStyle(fontSize: 20))
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 30, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
