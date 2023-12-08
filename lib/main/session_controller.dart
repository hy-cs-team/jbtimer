import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/storage/session_list_storage.dart';

class SessionController extends ValueNotifier<Session> {
  SessionController(Session session) : super(session) {
    select(session);
  }

  void select(Session session) {
    SessionListStorage.onSelect(session);
    value = session;
  }

  void add(Record record) {
    value = value.add(record);
  }

  void delete(Record record) {
    value = value.delete(record);
  }

  void rename(String newName) {
    value = value.rename(newName);
  }
}
