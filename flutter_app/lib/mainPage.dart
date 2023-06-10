import 'package:effectui/J_mealrecordUI.dart';
import 'package:effectui/wgraph.dart';
import 'package:flutter/material.dart';
import 'J_effectUI.dart';
import 'J_meallist.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          '먹어봤자 다 아는맛이다...\n 오늘도 화이팅이야!',
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Meal()));
              },
              child: Text('식단 입력'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFff923f),
                primary: Colors.blue,
                onPrimary: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    ));
  }
}
