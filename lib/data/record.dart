class Record {
  final DateTime dateTime;
  final int recordMs;

  Record({
    required this.dateTime,
    required this.recordMs,
  });

  Record.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.fromMicrosecondsSinceEpoch(json['dateTime']),
        recordMs = json['recordMs'];

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.millisecondsSinceEpoch,
      'recordMs': recordMs,
    };
  }
}
