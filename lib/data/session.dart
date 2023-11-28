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
    best = _getBest();
    worst = _getWorst();
    average = _records.length >= 3
        ? ((_sum() - best!.recordMs - worst!.recordMs) / (_records.length - 2))
            .round()
        : null;
  }

  _getBest() {
    Record? best;
    for (final record in _records) {
      if (best == null || record.recordMs < best.recordMs) {
        best = record;
      }
    }
    return best;
  }

  _getWorst() {
    Record? worst;
    for (final record in _records) {
      if (worst == null || record.recordMs > worst.recordMs) {
        worst = record;
      }
    }
    return worst;
  }

  _sum() {
    return _records.map((r) => r.recordMs).reduce((a, b) => a + b);
  }
}
