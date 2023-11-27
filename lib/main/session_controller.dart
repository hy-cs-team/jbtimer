import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';

class SessionController extends ValueNotifier<Session> {
  SessionController() : super(Session());

  void add(Record record) {
    value = value.add(record);
  }
}
