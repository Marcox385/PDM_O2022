// IS727272 - Cordero Hernández, Marco Ricardo
import 'package:flutter/material.dart'; // Librería principal
import 'package:tarea1/home_page.dart'; // Archivo de página principal

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mc Flutter',
      home: HomePage(),
    );
  }
}
