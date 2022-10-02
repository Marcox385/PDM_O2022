import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:FindTrackApp/identify/identify_screen.dart';

import 'identify/bloc/identify_bloc.dart';

Future main() async {
  await dotenv.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData mainTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigoAccent,
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]));
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindTrackApp',
      debugShowCheckedModeBanner: false,
      darkTheme: mainTheme,
      theme: mainTheme,
      // home: Scaffold(
      //   body: IdentifyScreen(),
      // ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<IdentifyBloc>(
            create: (BuildContext context) => IdentifyBloc()
          )
        ],
        child: IdentifyScreen())
    );
  }
}
