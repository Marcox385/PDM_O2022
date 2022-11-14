import 'package:findtrackapp_v2/favList/bloc/delete_fav_bloc.dart';
import 'package:findtrackapp_v2/login/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'identify/bloc/identify_bloc.dart';

Future main() async {
  // For Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // runApp(MyApp());
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<IdentifyBloc>(create: (BuildContext context) => IdentifyBloc()),
      BlocProvider<DeleteFavBloc>(create: (BuildContext context) => DeleteFavBloc())
    ], 
    child: MyApp()
  ));
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
        home: AuthService().handleAuthState()
    );
  }
}
