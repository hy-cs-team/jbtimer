import 'package:flutter/material.dart';
import 'package:jbtimer/main/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JBTimer',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          outline: Colors.white,
          surfaceTint: Colors.white10,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
