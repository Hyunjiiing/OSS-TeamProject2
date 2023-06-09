import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class Calender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableCalendarScreen(),
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
  TextEditingController nutritionalSupplementsController =
      TextEditingController();
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
    if (menstrualPeriodController.text.isEmpty) {
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

    if (nutritionalSupplementsController.text.isEmpty) {
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

    if (conditionController.text.isEmpty) {
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

    if (waterIntakeController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('섭취한 물의 양을 입력하세요.'),
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
    initializeDateFormatting();

    return Container(
      child: Column(
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
                nutritionalSupplementsController.text =
                    events[selectedDay]?[1] ?? '';
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
                    height: 5,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('월경기간'),
                    Row(
                      // Add row to include an icon
                      children: [
                        Icon(Icons.water_drop,
                            color:
                                const Color(0xFFFF923F)), // Add water drop icon
                        SizedBox(width: 8), // Add spacing
                        Expanded(
                          child: TextField(
                            controller: menstrualPeriodController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: const Color(0xFFFF923F)),
                              ),
                            ),
                            cursorColor: const Color(0xFFFF923F),
                            onChanged: (value) {
                              setState(() {
                                events[selectedDay]?[0] = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('섭취한 영양제'),
                    Row(
                      // Add row to include an icon
                      children: [
                        Icon(Icons.medication,
                            color: const Color(0xFFFF923F)), // Add pill icon
                        SizedBox(width: 8), // Add spacing
                        Expanded(
                          child: TextField(
                            controller: nutritionalSupplementsController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: const Color(0xFFFF923F)),
                              ),
                            ),
                            cursorColor: const Color(0xFFFF923F),
                            onChanged: (value) {
                              setState(() {
                                events[selectedDay]?[1] = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('컨디션'),
                    Row(
                      // Add row to include an icon
                      children: [
                        Icon(Icons.sentiment_satisfied,
                            color:
                                const Color(0xFFFF923F)), // Add happy face icon
                        SizedBox(width: 8), // Add spacing
                        Expanded(
                          child: TextField(
                            controller: conditionController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: const Color(0xFFFF923F)),
                              ),
                            ),
                            cursorColor: const Color(0xFFFF923F),
                            onChanged: (value) {
                              setState(() {
                                events[selectedDay]?[2] = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('섭취한 물의 양'),
                    Row(
                      // Add row to include an icon
                      children: [
                        Icon(Icons.local_drink,
                            color: const Color(0xFFFF923F)), // Add glass icon
                        SizedBox(width: 8), // Add spacing
                        Expanded(
                          child: TextField(
                            controller: waterIntakeController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: const Color(0xFFFF923F)),
                              ),
                            ),
                            cursorColor: const Color(0xFFFF923F),
                            onChanged: (value) {
                              setState(() {
                                events[selectedDay]?[3] = value;
                              });
                            },
                          ),
                        ),
                      ],
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
          ),
        ],
      ),
    );
  }
}
