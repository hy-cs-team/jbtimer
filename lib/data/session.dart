import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/record_list_stat.dart';

class Session {
  final List<Record> _records;

  RecordListStat get stat => _safe(_stat);

  late final RecordListStat _stat;

  bool _isStale = false;

  Session add(Record record) {
    _assertNotStale();

    _records.add(record);
    _isStale = true;
    return Session._copyFrom(this);
  }

  Session()
      : _records = [],
        _stat = RecordListStat.analyze([], 0, 0);

  Session._copyFrom(Session original) : _records = original._records {
    _stat = RecordListStat.analyze(_records, 0, _records.length);
  }

  T _safe<T>(T value) {
    _assertNotStale();

    return value;
  }

  _assertNotStale() {
    if (_isStale) {
      throw StateError('Cannot call add() from a stale Session.');
    }
  }
}
