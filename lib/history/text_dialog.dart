import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jbtimer/components/jb_button.dart';
import 'package:jbtimer/data/record.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/extensions/format_extensions.dart';

extension _StringBufferWriteExtension on StringBuffer {
  StringBuffer println(String? text) {
    if (text != null) {
      write(text);
    }
    writeln();
    return this;
  }
}

String _buildText(Session session) {
  final buffer = StringBuffer();
  buffer.println(session.name).writeln();

  buffer.println('* Generated by JBTimer *').writeln();

  buffer
      .println('Total ${session.stat.total} records')
      .println('Average: ${session.stat.average?.recordFormat ?? 'N/A'}')
      .println('Best: ${session.stat.best?.recordMs.recordFormat ?? 'N/A'}')
      .println('Worst: ${session.stat.worst?.recordMs ?? 'N/A'}')
      .writeln();

  buffer
      .println('Average of 5: ${session.avg5?.average ?? 'N/A'}')
      .println('Average of 12: ${session.avg12?.average ?? 'N/A'}')
      .println('Best of 5: ${session.best5?.average ?? 'N/A'}')
      .println('Best of 5: ${session.best12?.average ?? 'N/A'}')
      .writeln();

  final recordList = session.records;
  final int padSize = recordList.length.toString().length;
  for (int i = 0; i < recordList.length; i++) {
    Record record = recordList[i];

    final index = (i + 1).toString().padLeft(padSize);
    final recordMs = record == session.stat.best || record == session.stat.worst
        ? '(${record.recordMs.recordFormat})'
        : record.recordMs.recordFormat;

    buffer.println('$index. $recordMs');
  }

  return buffer.toString();
}

class TextSaveDialog extends AlertDialog {
  TextSaveDialog({
    super.key,
    required BuildContext context,
    required Session session,
  }) : super(
          content: Text(_buildText(session)),
          actions: [
            JBButton(
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: _buildText(session)));

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Session text copied to clipboard.',
                    ),
                  ),
                );
              },
              child: Text(
                'Copy',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const JBButton(child: Text('Save')),
          ],
        );
}
