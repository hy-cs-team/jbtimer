import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/jb_component.dart';
import 'package:jbtimer/main/session_controller.dart';

class RecordArea extends StatelessWidget {
  final SessionController sessionController;
  const RecordArea({super.key, required this.sessionController});

  @override
  Widget build(BuildContext context) {
    return JBComponent(
      onPressed: () {
        sessionController.add(Record(dateTime: DateTime.now(), recordMs: Random().nextInt(15000) + 15000));
      },
      child: const Center(
        child: Text('0:00.000'),
      ),
    );
  }
}
