import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';

class SessionController extends ValueNotifier<Session> {
  SessionController() : super(Session()) {
    Session.load('default').then((session) {
      if (session != null) {
        value = session;
      }
    });
  }

  void add(Record record) {
    value = value.add(record);
  }

  void delete(Record record) {
    value = value.delete(record);
  }
}
