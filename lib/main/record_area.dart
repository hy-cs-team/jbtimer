import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/session_controller.dart';

enum RecordState {
  idle,
  preview,
  penalty,
  running;

  getColorByState(RecordState state) {
    switch (state) {
      case RecordState.idle:
        return const Color(0xFF000000);
      case RecordState.preview:
        return const Color(0xFF453C67);
      case RecordState.penalty:
        return const Color(0xFF6D67E4);
      case RecordState.running:
        return const Color(0xFF46C2CB);
    }
  }
}

class RecordArea extends StatefulWidget {
  final SessionController sessionController;
  const RecordArea({super.key, required this.sessionController});

  @override
  State<RecordArea> createState() => _RecordAreaState();
}

class _RecordAreaState extends State<RecordArea> {
  @override
  Widget build(BuildContext context) {
    return JBComponent(
      onPressed: () {
        widget.sessionController.add(Record(
            dateTime: DateTime.now(),
            recordMs: Random().nextInt(15000) + 15000));
      },
      child: const Center(
        child: Text('0:00.000'),
      ),
    );
  }
}
