import 'package:jbtimer/data/record.dart';

class RecordListStat {
  late final int total;
  late final int? average;
  late final Record? best;
  late final Record? worst;

  RecordListStat._({
    required this.total,
    this.average,
    this.best,
    this.worst,
  });

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
    return RecordListStat._(
      total: end - start,
      best: best,
      worst: worst,
      average: average,
    );
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
