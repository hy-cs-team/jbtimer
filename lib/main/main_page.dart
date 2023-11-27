import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';
import 'package:jbtimer/history/history_page.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/record_area.dart';
import 'package:jbtimer/main/session_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final SessionController _sessionController = SessionController();

  @override
  void dispose() {
    _sessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            JBComponent(
              child: Statistics(
                sessionController: _sessionController,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(
                      sessionController: _sessionController,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: RecordArea(
                sessionController: _sessionController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
