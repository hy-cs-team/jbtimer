import 'package:flutter/material.dart';
import 'package:jbtimer/extensions/format_extensions.dart';

class StatisticsItem extends StatelessWidget {
  final String name;
  final int? record;
  final String? text;
  final double? standardDeviation;
  final Color? recordColor;

  const StatisticsItem({
    super.key,
    required this.name,
    this.record,
    this.text,
    this.standardDeviation,
    this.recordColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 12.0,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: record?.recordFormat ?? text ?? 'N/A',
                style: TextStyle(
                  color: recordColor ?? Theme.of(context).colorScheme.onSurface,
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
