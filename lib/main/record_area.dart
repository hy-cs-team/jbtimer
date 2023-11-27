import 'package:flutter/material.dart';
import 'package:jbtimer/jb_component.dart';

class RecordArea extends StatelessWidget {
  const RecordArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const JBComponent(
      child: Center(
        child: Text('0:00.000'),
      ),
    );
  }
}
