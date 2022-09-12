// 727272 - Cordero Hernández, Marco Ricardo
import 'package:flutter/material.dart';
import 'package:tip_time/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xff4cb051)),
      home: HomePage(),
    );
  }
}
