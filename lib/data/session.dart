import 'package:jbtimer/data/record.dart';

class Session {
  final List<Record> _records;

  int get total => _records.length;

  bool _isStale = false;

  Session add(Record record) {
    if (_isStale) {
      throw StateError('Cannot call add() from a stale Session.');
    }

    _records.add(record);
    _isStale = true;
    return Session._copyFrom(this);
  }

  Session() : _records = [];

  Session._copyFrom(Session original) : _records = original._records {}
}
