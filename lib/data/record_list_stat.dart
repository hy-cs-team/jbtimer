import 'dart:math';

import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/extensions/format_extensions.dart';

class RecordListStat {
  late final int total;
  late final int? average;
  late final double? standardDeviation;
  late final Record? best;
  late final Record? worst;

  late final String? short;

  RecordListStat._({
    required this.total,
    this.average,
    this.standardDeviation,
    this.best,
    this.worst,
  }) {
    short = _getShortString(average, standardDeviation);
  }

  factory RecordListStat.analyze(List<Record> recordList, int start, int end) {
    int total = end - start;
    Record? best = _getBest(recordList, start, end);
    Record? worst = _getWorst(recordList, start, end);
    if (total < 3) {
      return RecordListStat._(
        total: end - start,
        best: best,
        worst: worst,
      );
    }

    int average = _getAverage(recordList, start, end);
    double standardDeviation = _getStandardDeviation(recordList, start, end);
    return RecordListStat._(
      total: end - start,
      best: best,
      worst: worst,
      average: average,
      standardDeviation: standardDeviation,
    );
  }

  static String? _getShortString(int? average, double? standardDeviation) {
    if (average == null) {
      return null;
    }

    String avgString = average.recordFormat;
    if (standardDeviation == null) {
      return avgString;
    }

    return '$avgString (σ=${standardDeviation.toStringAsFixed(2)})';
  }

  static double _getStandardDeviation(
      List<Record> recordList, int start, int end) {
    if (start == end) {
      return 0.0;
    }

    double mean = 0;
    for (int i = start; i < end; i++) {
      mean += recordList[i].recordMs;
    }
    mean /= end - start;

    double squaredDifferencesSum = 0.0;
    for (int i = start; i < end; i++) {
      squaredDifferencesSum += pow(recordList[i].recordMs - mean, 2);
    }

    double variance = squaredDifferencesSum / (end - start - 1);
    return sqrt(variance) / 1000;
  }

  static _getBest(List<Record> recordList, int start, int end) {
    Record? best;
    for (int i = start; i < end; i++) {
      final record = recordList[i];
      if (best == null || record.recordMs < best.recordMs) {
        best = record;
      }
    }
    return best;
  }

  static _getWorst(List<Record> recordList, int start, int end) {
    Record? worst;
    for (int i = start; i < end; i++) {
      final record = recordList[i];
      if (worst == null || record.recordMs > worst.recordMs) {
        worst = record;
      }
    }
    return worst;
  }

  static _getAverage(List<Record> recordList, int start, int end) {
    int sum = 0;
    int best = 4294967296; // max int value (approx. 49.71 days)
    int worst = 0;

    for (int i = start; i < end; i++) {
      final record = recordList[i];
      sum += record.recordMs;
      if (record.recordMs < best) {
        best = record.recordMs;
      }
      if (record.recordMs > worst) {
        worst = record.recordMs;
      }
    }

    return ((sum - best - worst) / (end - start)).round();
  }
}
