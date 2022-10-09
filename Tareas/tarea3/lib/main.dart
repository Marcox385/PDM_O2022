import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea3/Pages/Home/bloc/search_bloc.dart';
import 'package:tarea3/Pages/Home/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LFTU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey[800])
      ),
      home: BlocProvider(
        create: (context) => SearchBloc(),
        child: HomeScreen(),
      )
    );
  }
}