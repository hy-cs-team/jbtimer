import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/storage/session_storage.dart';

class SessionController extends ValueNotifier<Session> {
  SessionController() : super(Session()) {
    SessionStorage.load(Session.defaultId)
        .catchError((error) => value)
        .then((session) => value = session);
  }

  void add(Record record) {
    value = value.add(record);
  }

  void delete(Record record) {
    value = value.delete(record);
  }
}
