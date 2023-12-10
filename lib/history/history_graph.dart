import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

    final verticalSteps = MediaQuery.of(context).size.width / 50;
    final verticalInterval = (_records.length / verticalSteps).ceilToDouble();

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
                    bottomTitleWidgets(value, meta, 0, _records.length - 1.0),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: horizontalInterval,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 50,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 0,
          maxX: _records.length - 1.0,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: _records
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(
                        entry.key as double,
                        entry.value.recordMs as double,
                      ))
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
    // if (value == start || value == end) {
    //   return const SizedBox();
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
          (value + 1).round().toString(),
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
