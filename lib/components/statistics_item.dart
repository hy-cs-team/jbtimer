import 'package:flutter/material.dart';

class StatisticsItem extends StatelessWidget {
  final String name;
  final String value;

  const StatisticsItem({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 12.0),
        ),
        Text(value),
      ],
    );
  }
}
