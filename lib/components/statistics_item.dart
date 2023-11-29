import 'package:flutter/material.dart';
import 'package:jbtimer/extensions/format_extensions.dart';

class StatisticsItem extends StatelessWidget {
  final String name;
  final int? record;
  final double? standardDeviation;

  const StatisticsItem({
    super.key,
    required this.name,
    required this.record,
    this.standardDeviation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 12.0),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: record?.recordFormat ?? 'N/A',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (record != null && standardDeviation != null)
                TextSpan(
                  text: ' (σ=${standardDeviation!.toStringAsFixed(2)})',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12.0,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
