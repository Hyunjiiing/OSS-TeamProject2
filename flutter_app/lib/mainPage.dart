import 'package:effectui/J_mealrecordUI.dart';
import 'package:effectui/wgraph.dart';
import 'package:flutter/material.dart';
import 'J_effectUI.dart';
import 'J_meallist.dart';
import 'settings.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
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
                  backgroundImage: AssetImage('images/foxcharacter.png'),
                  radius: 70,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '사용자 이름: OWA',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '체중: 56kg',
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
              '먹어봤자 다 아는 맛이다...\n 오늘도 화이팅이야!',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
              textAlign: TextAlign.center,
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
                        context,
                        MaterialPageRoute(builder: (context) => Meal()));
                  },
                  child: Text('식단 입력'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff923f),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 버튼이 눌렸을 때 수행할 작업
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MealList()));
                  },
                  child: Text('식단 기록'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFff923f),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WeightTrackerApp()));
                  },
                  child: Text('체중 그래프'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFff923f),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 버튼이 눌렸을 때 수행할 작업
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DietCalculatorScreen()));
                  },
                  child: Text('일일 섭취량'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFff923f),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ));
  }
}