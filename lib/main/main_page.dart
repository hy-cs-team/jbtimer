import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';
import 'package:jbtimer/extensions/list_dispose_extensions.dart';
import 'package:jbtimer/history/history_page.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/record_area.dart';
import 'package:jbtimer/main/session_button.dart';
import 'package:jbtimer/main/session_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final List<SessionController> _sessionControllers;
  int _selectedSessionIndex = 0;

  get _sessionController => _sessionControllers[_selectedSessionIndex];

  @override
  void initState() {
    _sessionControllers = [SessionController()];
    super.initState();
  }

  @override
  void dispose() {
    _sessionControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SessionButton(
              sessionControllers: _sessionControllers,
              selectedSessionIndex: _selectedSessionIndex,
              onSelectedSessionIndexChanged: (index) => setState(() {
                _selectedSessionIndex = index;
              }),
            ),
            const SizedBox(height: 8.0),
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
