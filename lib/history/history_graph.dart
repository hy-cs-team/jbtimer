import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/extensions/format_extensions.dart';
import 'package:jbtimer/main/session_controller.dart';

List<Color> gradientColors = [
  Colors.cyan,
  Colors.blue,
];

class HistoryGraph extends StatelessWidget {
  final SessionController sessionController;
  final List<Record> _records;

  HistoryGraph({super.key, required this.sessionController})
      : _records = sessionController.value.records;

  @override
  Widget build(BuildContext context) {
    if (_records.isEmpty) {
      return const Center(child: Text('No records'));
    }

    final firstRecordAt = _records.first.dateTime.millisecondsSinceEpoch;
    final lastRecordAt = _records.last.dateTime.millisecondsSinceEpoch;
    final timeGap = lastRecordAt - firstRecordAt;
    final timeWindowPadding = timeGap > 0 ? timeGap * 0.1 : 30000.0;
    final timeWindowSize = timeGap + timeWindowPadding * 2;

    final minX = firstRecordAt - timeWindowPadding;
    final maxX = lastRecordAt + timeWindowPadding;

    final verticalSteps = MediaQuery.of(context).size.width / 50;
    final verticalInterval = timeWindowSize / verticalSteps;

    final maxRecordMs = sessionController.value.stat.worst?.recordMs ?? 0;
    final maxY = maxRecordMs * 1.2;

    final horizontalSteps = MediaQuery.of(context).size.height / 50;
    final horizontalInterval = maxRecordMs / horizontalSteps;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: horizontalInterval,
            verticalInterval: verticalInterval,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: Colors.white30,
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => const FlLine(
              color: Colors.white30,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: verticalInterval * 3,
                getTitlesWidget: (value, meta) =>
                    bottomTitleWidgets(value, meta, minX, maxX),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: verticalInterval,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 50,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: _records
                  .map((record) => FlSpot(
                      record.dateTime.millisecondsSinceEpoch as double,
                      record.recordMs as double))
                  .toList(),
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, double start, double end) {
    if (value == start || value == end) {
      return const SizedBox();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        DateFormat.jms()
            .format(DateTime.fromMillisecondsSinceEpoch(value.round())),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Text(
        value.round().recordFormat,
        style: style,
        textAlign: TextAlign.right,
      ),
    );
  }
}
