import 'package:flutter/material.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';

class HistoryList extends StatelessWidget {
  final Session session;
  late final List<Record> records;

  HistoryList({super.key, required this.session}) {
    records = session.records;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return const Placeholder();
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: session.stat.total,
    );
  }
}
