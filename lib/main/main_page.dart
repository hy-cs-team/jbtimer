import 'package:flutter/material.dart';
import 'package:jbtimer/main/record_area.dart';
import 'package:jbtimer/main/statistics.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Statistics(),
            SizedBox(height: 8.0),
            Expanded(child: RecordArea()),
          ],
        ),
      ),
    );
  }
}
