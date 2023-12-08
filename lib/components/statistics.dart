import 'package:flutter/material.dart';
import 'package:jbtimer/components/highlighted_statistics_item.dart';
import 'package:jbtimer/components/statistics_item.dart';
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
      builder: (context, session, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getColumnCount(context),
            crossAxisSpacing: 18.0,
            mainAxisExtent: 20.0,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            StatisticsItem(
              name: 'total',
              text:
                  '${session.stat.total} record${session.stat.total > 1 ? 's' : ''}',
            ),
            StatisticsItem(
              name: 'average',
              record: session.stat.average,
              standardDeviation: session.stat.standardDeviation,
            ),
            HighlightedStatisticsItem(
              name: 'best',
              record: session.stat.best?.recordMs,
              recordHighlightColor: Colors.blue,
            ),
            HighlightedStatisticsItem(
              name: 'worst',
              record: session.stat.worst?.recordMs,
              recordHighlightColor: Colors.red,
            ),
            HighlightedStatisticsItem(
              name: 'best 5',
              record: session.best5?.average,
              standardDeviation: session.best5?.standardDeviation,
              recordHighlightColor: Colors.blue,
            ),
            StatisticsItem(
              name: 'avg 5',
              record: session.avg5?.average,
              standardDeviation: session.avg5?.standardDeviation,
            ),
            HighlightedStatisticsItem(
              name: 'best 12',
              record: session.best12?.average,
              standardDeviation: session.best12?.standardDeviation,
              recordHighlightColor: Colors.blue,
            ),
            StatisticsItem(
              name: 'avg 12',
              record: session.avg12?.average,
              standardDeviation: session.avg12?.standardDeviation,
            ),
          ],
        ),
      ),
    );
  }

  int _getColumnCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width >= 600) {
      return 4;
    }
    return 2;
  }
}
