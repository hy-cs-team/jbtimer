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
                  value: session.best5?.average?.recordFormat ?? 'N/A',
                ),
                StatisticsItem(
                  name: 'avg of 5',
                  value: session.avg5?.average?.recordFormat ?? 'N/A',
                ),
                StatisticsItem(
                  name: 'best 12',
                  value: session.best12?.average?.recordFormat ?? 'N/A',
                ),
                StatisticsItem(
                  name: 'avg of 12',
                  value: session.avg12?.average?.recordFormat ?? 'N/A',
                ),
                StatisticsItem(
                  name: 'best',
                  value: session.stat.best?.recordMs.recordFormat ?? 'N/A',
                ),
                StatisticsItem(
                  name: 'worst',
                  value: session.stat.worst?.recordMs.recordFormat ?? 'N/A',
                ),
                StatisticsItem(
                  name: 'average',
                  value: session.stat.average?.recordFormat ?? 'N/A',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
