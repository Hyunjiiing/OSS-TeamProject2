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

  TextEditingController memoController = TextEditingController();

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    memoController.text = events[selectedDay]?.join('\n') ?? '';
    });
    },
    eventLoader: (day) {
    return events[day] ?? [];
    },
    calendarBuilders: CalendarBuilders(
    markerBuilder: (context, day, events) {
    if (events.isNotEmpty) {}