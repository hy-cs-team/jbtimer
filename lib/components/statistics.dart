import 'package:flutter/material.dart';
import 'package:jbtimer/components/statistics_item.dart';
import 'package:jbtimer/extensions/format_extensions.dart';
import 'package:jbtimer/main/session_controller.dart';

class Statistics extends StatelessWidget {
  final SessionController sessionController;
  final bool showTotalCount;

  const Statistics({
    super.key,
    required this.sessionController,
    this.showTotalCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: sessionController,
      builder: (context, session, child) => Column(
        children: [
          if (showTotalCount) ...[
            const SizedBox(height: 8.0),
            Center(
              child: Text(
                '${session.stat.total} records',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
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
              children: [
                StatisticsItem(
                  name: 'best 5',
                  record: session.best5?.average,
                  standardDeviation: session.best5?.standardDeviation,
                ),
                StatisticsItem(
                  name: 'avg 5',
                  record: session.avg5?.average,
                  standardDeviation: session.avg5?.standardDeviation,
                ),
                StatisticsItem(
                  name: 'best 12',
                  record: session.best12?.average,
                  standardDeviation: session.best12?.standardDeviation,
                ),
                StatisticsItem(
                  name: 'avg 12',
                  record: session.avg12?.average,
                  standardDeviation: session.avg12?.standardDeviation,
                ),
                StatisticsItem(
                  name: 'best',
                  record: session.stat.best?.recordMs,
                ),
                StatisticsItem(
                  name: 'worst',
                  record: session.stat.worst?.recordMs,
                ),
                StatisticsItem(
                  name: 'average',
                  record: session.stat.average,
                  standardDeviation: session.stat.standardDeviation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
