import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/storage/session_list_storage.dart';
import 'package:jbtimer/storage/session_storage.dart';

class SessionController extends ValueNotifier<Session> {
  SessionController(Session session) : super(session) {
    selectSession(session);
  }

  void selectSession(Session session) {
    SessionListStorage.onSelect(session);
    value = session;
  }

  void renameSession(String newName) {
    value = value.rename(newName);
  }

  Future<void> deleteSession() async {
    SessionStorage.delete(value);
    final sessionIdentifier = await SessionListStorage.delete(value);
    if (sessionIdentifier == null) {
      value = Session();
    } else {
      value = await SessionStorage.load(sessionIdentifier.id) ?? Session();
    }
  }

  void addRecord(Record record) {
    value = value.add(record);
  }

  void deleteRecord(Record record) {
    value = value.delete(record);
  }
}
