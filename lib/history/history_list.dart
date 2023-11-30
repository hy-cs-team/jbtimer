import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jbtimer/extensions/format_extensions.dart';
import 'package:jbtimer/main/session_controller.dart';

class HistoryList extends StatelessWidget {
  final SessionController sessionController;

  const HistoryList({super.key, required this.sessionController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: sessionController,
      builder: (context, session, child) {
        final records = session.records;
        return ListView.separated(
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
              subtitle:
                  const Text('S O M\' E R A2 N D O\' M\' S C R A M B L E'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.recordMs.recordFormat,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          DateFormat.yMMMd().add_jms().format(record.dateTime),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    content: const Text(
                        'S O M\' E R A2 N D O\' M\' S C R A M B L E'),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          sessionController.delete(record);
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: session.stat.total,
        );
      },
    );
  }
}
