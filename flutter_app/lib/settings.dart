import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ChangeNotifierProvider<Settings>(
    create: (context) => Settings(),
    child: MyApp(),
  ));
}
