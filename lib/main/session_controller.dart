import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';

class SessionController extends ValueNotifier<Session> {
  SessionController(Session session) : super(session);

  void add(Record record) {
    value = value.add(record);
  }

  void delete(Record record) {
    value = value.delete(record);
  }
}
