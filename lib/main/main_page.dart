import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';
import 'package:jbtimer/history/history_page.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/record_area.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            JBComponent(
              child: const Statistics(),
              onPressed: () {
                print('pressed');
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ));
              },
            ),
            const SizedBox(height: 8.0),
            const Expanded(child: RecordArea()),
          ],
        ),
      ),
    );
  }
}
