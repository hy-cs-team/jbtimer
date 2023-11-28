import 'package:jbtimer/data/record.dart';

class Session {
  final List<Record> _records;

  late final int total;
  late final int? average;
  late final Record? best;
  late final Record? worst;

  bool _isStale = false;

  Session add(Record record) {
    if (_isStale) {
      throw StateError('Cannot call add() from a stale Session.');
    }

    _records.add(record);
    _isStale = true;
    return Session._copyFrom(this);
  }

  Session()
      : _records = [],
        total = 0,
        average = null,
        best = null,
        worst = null;

  Session._copyFrom(Session original) : _records = original._records {
    total = _records.length;
    average = (_records.map((r) => r.recordMs).reduce((a, b) => a + b) /
            _records.length)
        .round();
    best = _findBest();
    worst = _findWorst();
  }

  _findBest() {
    Record? best;
    for (final record in _records) {
      if (best == null || record.recordMs < best.recordMs) {
        best = record;
      }
    }
    return best;
  }

  _findWorst() {
    Record? worst;
    for (final record in _records) {
      if (worst == null || record.recordMs > worst.recordMs) {
        worst = record;
      }
    }
    return worst;
  }
}
