import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Statistics(),
        ],
      ),
    );
  }
}
