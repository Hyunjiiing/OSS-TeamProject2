import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TableCalendarScreen(),
    );
  }
}

class TableCalendarScreen extends StatefulWidget {
  const TableCalendarScreen({Key? key}) : super(key: key);

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();
  Map<DateTime, List<String>> events = {};

  TextEditingController menstrualPeriodController = TextEditingController();
  TextEditingController nutritionalSupplementsController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  TextEditingController waterIntakeController = TextEditingController();

  @override
  void dispose() {
    menstrualPeriodController.dispose();
    nutritionalSupplementsController.dispose();
    conditionController.dispose();
    waterIntakeController.dispose();
    super.dispose();
  }

  void saveEvent() {
    if (menstrualPeriodController.text.isEmpty) { // 수정된 부분: 월경기간 입력 확인
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('월경기간을 입력하세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (nutritionalSupplementsController.text.isEmpty) { // 수정된 부분: 영양제 입력 확인
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('섭취한 영양제를 입력하세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (conditionController.text.isEmpty) { // 수정된 부분: 컨디션 입력 확인
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('컨디션을 입력하세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      events[selectedDay] = [
        menstrualPeriodController.text,
        nutritionalSupplementsController.text,
        conditionController.text,
        waterIntakeController.text,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF923F),
        title: Text('캘린더'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2021, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: focusedDay,
            selectedDayPredicate: (DateTime day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
                menstrualPeriodController.text = events[selectedDay]?[0] ?? '';
                nutritionalSupplementsController.text = events[selectedDay]?[1] ?? '';
                conditionController.text = events[selectedDay]?[2] ?? '';
                waterIntakeController.text = events[selectedDay]?[3] ?? '';
              });
            },
            eventLoader: (day) {
              return events[day] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF923F),
                    ),
                  );
                }
                return null;
              },
              selectedBuilder: (context, day, events) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF923F),
                  ),
                  margin: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              todayBuilder: (context, day, events) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF923F),
                  ),
                  margin: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('월경기간'),
                  TextField(
                    controller: menstrualPeriodController,
                    onChanged: (value) {
                      setState(() {
                        events[selectedDay]?[0] = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text('섭취한 영양제'),
                  TextField(
                    controller: nutritionalSupplementsController,
                    onChanged: (value) {
                      setState(() {
                        events[selectedDay]?[1] = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text('컨디션'),
                  TextField(
                    controller: conditionController,
                    onChanged: (value) {
                      setState(() {
                        events[selectedDay]?[2] = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text('섭취한 물의 양'),
                  TextField(
                    controller: waterIntakeController,
                    onChanged: (value) {
                      setState(() {
                        events[selectedDay]?[3] = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: saveEvent,
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFFF923F),
                    ),
                    child: Text('저장'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
