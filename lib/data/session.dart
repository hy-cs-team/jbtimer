import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/record_list_stat.dart';
import 'package:jbtimer/storage/session_list_storage.dart';
import 'package:jbtimer/storage/session_storage.dart';

class Session {
  static const defaultId = 'default';
  static const defaultName = 'Default Session';

  final String id;

  String _name;

  String get name => _safe(_name);

  final List<Record> _records;

  List<Record> get records => List.from(_safe(_records));

  RecordListStat get stat => _safe(_stat);

  RecordListStat? get best5 => _safe(_best5);

  RecordListStat? get best12 => _safe(_best12);

  RecordListStat? get avg5 => _safe(_avg5);

  RecordListStat? get avg12 => _safe(_avg12);

  late final RecordListStat _stat;
  late final RecordListStat? _best5;
  late final RecordListStat? _best12;
  late final RecordListStat? _avg5;
  late final RecordListStat? _avg12;

  bool _isStale = false;

  Session add(Record record) {
    return _safeExecute(() {
      _records.add(record);
    });
  }

  Session delete(Record record) {
    return _safeExecute(() {
      _records.remove(record);
    });
  }

  Session rename(String newName) {
    return _safeExecute(() {
      _name = newName;
    });
  }

  Session({String name = defaultName})
      : _name = name,
        id = name == defaultName
            ? defaultId
            : 'session${DateTime.now().millisecondsSinceEpoch}',
        _records = [],
        _stat = RecordListStat.analyze([], 0, 0),
        _best5 = null,
        _best12 = null,
        _avg5 = null,
        _avg12 = null {
    SessionStorage.save(this);
    SessionListStorage.onCreate(this);
  }

  Session.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _name = json['name'],
        _records = (json['records'] as List<dynamic>)
            .map((recordJson) => Record.fromJson(recordJson))
            .toList() {
    _recalculateStats();
  }

  Session._copyFrom(Session original)
      : id = original.id,
        _records = original._records,
        _name = original.name {
    _recalculateStats();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'records': records.map((e) => e.toJson()).toList(),
    };
  }

  void _recalculateStats() {
    _stat = RecordListStat.analyze(_records, 0, _records.length);
    _best5 = _getBestStat(5);
    _best12 = _getBestStat(12);
    _avg5 = _getLastStat(5);
    _avg12 = _getLastStat(12);
  }

  T _safe<T>(T value) {
    _assertNotStale();

    return value;
  }

  Session _safeExecute(void Function() job) {
    _assertNotStale();

    job.call();

    Session newSession = Session._copyFrom(this);
    SessionStorage.save(newSession);

    _isStale = true;
    return newSession;
  }

  void _assertNotStale() {
    if (_isStale) {
      throw StateError('Cannot call methods from a stale Session.');
    }
  }

  RecordListStat? _getBestStat(int length) {
    if (length < 3) {
      throw ArgumentError(
          'length of the best record sequence should be at least 3.');
    }

    RecordListStat? bestStat;
    for (int start = 0; start <= _records.length - length; start++) {
      int end = start + length;
      RecordListStat stat = RecordListStat.analyze(_records, start, end);

      if (bestStat == null || stat.average! < bestStat.average!) {
        bestStat = stat;
      }
    }
    return bestStat;
  }

  RecordListStat? _getLastStat(int length) {
    if (length < 3) {
      throw ArgumentError(
          'length of the best record sequence should be at least 3.');
    }

    if (_records.length < length) {
      return null;
    }

    return RecordListStat.analyze(
        _records, _records.length - length, _records.length);
  }
}
