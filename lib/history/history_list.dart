import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/extensions/format_extensions.dart';

class HistoryList extends StatelessWidget {
  final Session session;
  late final List<Record> records;

  HistoryList({super.key, required this.session}) {
    records = session.records;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemBuilder: (context, index) {
          final record = records[index];
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.recordMs.recordFormat,
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  DateFormat.yMMMd().add_jms().format(record.dateTime),
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            subtitle: const Text('S O M\' E R A2 N D O\' M\' S C R A M B L E'),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: session.stat.total,
      ),
    );
  }
}
