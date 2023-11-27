import 'package:flutter/material.dart';
import 'package:jbtimer/jb_component.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return const JBComponent(
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text('통계'),
        ),
      ),
    );
  }
}
