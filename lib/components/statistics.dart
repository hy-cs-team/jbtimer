import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics_item.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        Center(
          child: Text(
            '0 records',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 18.0,
              mainAxisExtent: 20.0,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              StatisticsItem(name: 'best 5', value: 'N/A'),
              StatisticsItem(name: 'avg of 5', value: 'N/A'),
              StatisticsItem(name: 'best 12', value: 'N/A'),
              StatisticsItem(name: 'avg of 12', value: 'N/A'),
              StatisticsItem(name: 'best', value: 'N/A'),
              StatisticsItem(name: 'worst', value: 'N/A'),
              StatisticsItem(name: 'average', value: 'N/A'),
            ],
          ),
        ),
      ],
    );
  }
}
