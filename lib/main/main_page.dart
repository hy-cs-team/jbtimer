import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/history/history_page.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/record_area.dart';
import 'package:jbtimer/main/session_button.dart';
import 'package:jbtimer/main/session_controller.dart';
import 'package:jbtimer/storage/session_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ValueNotifier<bool> _isRecordRunningNotifier = ValueNotifier(false);
  late final SessionController _sessionController;
  bool _isLoaded = false;

  @override
  void initState() {
    SessionStorage.loadSelected().then((session) {
      _sessionController = SessionController(session ?? Session());
      setState(() {
        _isLoaded = true;
      });
    });
    super.initState();
  }

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
        child: _isLoaded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _isRecordRunningNotifier,
                    builder: (context, isRecordRunning, child) {
                      return AnimatedSize(
                        duration: const Duration(milliseconds: 70),
                        child: SizedBox(
                          height: isRecordRunning ? 0 : null,
                          child: Column(
                            children: [
                              SessionButton(
                                sessionController: _sessionController,
                              ),
                              const SizedBox(height: 8.0),
                              JBComponent(
                                child: Statistics(
                                  sessionController: _sessionController,
                                ),
                                onTap: () {
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: RecordArea(
                      sessionController: _sessionController,
                      isRecordRunningNotifier: _isRecordRunningNotifier,
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
