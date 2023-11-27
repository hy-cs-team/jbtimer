import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total 0 records'),
        centerTitle: true,
      ),
      body: const Column(
        children: [
          Statistics(showTotalCount: false),
          Divider(
            thickness: 1.0,
            indent: 12.0,
            endIndent: 12.0,
          ),
        ],
      ),
    );
  }
}
