import 'package:flutter/material.dart';
import 'package:jbtimer/main/main_page.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JBTimer',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          outline: Colors.white,
          surfaceTint: Colors.white10,
          onSurfaceVariant: Colors.grey,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
