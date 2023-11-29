import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';
import 'package:jbtimer/history/history_list.dart';
import 'package:jbtimer/main/session_controller.dart';

class HistoryPage extends StatelessWidget {
  final SessionController sessionController;

  const HistoryPage({
    super.key,
    required this.sessionController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: sessionController,
          builder: (context, value, child) =>
              Text('Total ${value.stat.total} records'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Statistics(
            sessionController: sessionController,
            showTotalCount: false,
          ),
          const Divider(
            thickness: 1.0,
            indent: 12.0,
            endIndent: 12.0,
          ),
          Expanded(child: HistoryList(session: sessionController.value)),
        ],
      ),
    );
  }
}
